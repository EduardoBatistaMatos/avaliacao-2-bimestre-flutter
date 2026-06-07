import 'package:flutter/material.dart';

import '../../components/editor.dart';
import '../../models/evento.dart';
import '../../repository/evento_repository.dart';

class FormularioEvento extends StatefulWidget {
  final EventoRepository repository;
  final Evento? evento;

  const FormularioEvento({
    super.key,
    required this.repository,
    this.evento,
  });

  @override
  State<FormularioEvento> createState() => _FormularioEventoState();
}

class _FormularioEventoState extends State<FormularioEvento> {
  late final TextEditingController _nomeController;
  late final TextEditingController _localController;
  late final TextEditingController _dataController;
  bool _salvando = false;

  bool get _modoEdicao => widget.evento != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.evento?.nome);
    _localController = TextEditingController(text: widget.evento?.local);
    _dataController = TextEditingController(text: widget.evento?.data);
  }

  Future<void> _salvar() async {
    final nome = _nomeController.text.trim();
    final local = _localController.text.trim();
    final data = _dataController.text.trim();

    if (nome.isEmpty || local.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      if (_modoEdicao) {
        await widget.repository.atualizar(
          Evento(id: widget.evento!.id, nome: nome, local: local, data: data),
        );
      } else {
        await widget.repository.salvar(
          Evento(nome: nome, local: local, data: data),
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_modoEdicao ? 'Evento atualizado!' : 'Evento salvo!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar Evento' : 'Novo Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Editor(label: 'Nome', controller: _nomeController),
            Editor(label: 'Local', controller: _localController),
            Editor(label: 'Data', controller: _dataController),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              onPressed: _salvando ? null : _salvar,
              child: _salvando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
