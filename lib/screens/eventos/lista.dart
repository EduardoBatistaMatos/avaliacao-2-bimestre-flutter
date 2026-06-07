import 'package:flutter/material.dart';

import '../../models/evento.dart';
import '../../repository/evento_repository.dart';
import 'formulario.dart';

class ListaEventos extends StatefulWidget {
  final EventoRepository repository;

  const ListaEventos({super.key, required this.repository});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  List<Evento> _eventos = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final eventos = await widget.repository.listarTodos();
      if (!mounted) return;
      setState(() {
        _eventos = eventos;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString();
        _carregando = false;
      });
    }
  }

  Future<void> _abrirFormulario({Evento? evento}) async {
    final alterou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioEvento(
          repository: widget.repository,
          evento: evento,
        ),
      ),
    );
    if (alterou == true) _carregarEventos();
  }

  Future<void> _confirmarDelecao(Evento evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir evento'),
        content: Text('Deseja excluir "${evento.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    try {
      await widget.repository.deletar(evento.id!);
      if (!mounted) return;
      _carregarEventos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Erro: $_erro', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregarEventos,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_eventos.isEmpty) {
      return const Center(child: Text('Nenhum evento cadastrado'));
    }

    return ListView.builder(
      itemCount: _eventos.length,
      itemBuilder: (context, index) {
        final evento = _eventos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(evento.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Local: ${evento.local}'),
                Text('Data: ${evento.data}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _abrirFormulario(evento: evento),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarDelecao(evento),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
