import '../models/evento.dart';
import '../db/database_helper.dart';
import 'evento_repository.dart';

class EventoRepositoryLocal implements EventoRepository {
  final DatabaseHelper _db = DatabaseHelper();

  @override
  Future<List<Evento>> listarTodos() => _db.listarTodos();

  @override
  Future<void> salvar(Evento evento) async {
    await _db.inserir(evento);
  }

  @override
  Future<void> atualizar(Evento evento) async {
    await _db.atualizar(evento);
  }

  @override
  Future<void> deletar(int id) async {
    await _db.deletar(id);
  }
}
