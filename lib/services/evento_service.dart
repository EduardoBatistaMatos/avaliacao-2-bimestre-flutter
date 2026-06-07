import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evento.dart';
import 'api_config.dart';

class EventoService {
  static const _endpoint = '${ApiConfig.baseUrl}/eventos';

  Future<List<Evento>> listarTodos() async {
    final response = await http.get(Uri.parse(_endpoint));
    _assertOk(response, 'listarTodos');
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Evento.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> salvar(Evento evento) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': evento.nome, 'local': evento.local, 'data': evento.data}),
    );
    _assertOk(response, 'salvar');
  }

  Future<void> atualizar(Evento evento) async {
    final response = await http.put(
      Uri.parse('$_endpoint/${evento.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': evento.nome, 'local': evento.local, 'data': evento.data}),
    );
    _assertOk(response, 'atualizar');
  }

  Future<void> deletar(int id) async {
    final response = await http.delete(Uri.parse('$_endpoint/$id'));
    _assertOk(response, 'deletar');
  }

  void _assertOk(http.Response response, String operacao) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro em $operacao — HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
