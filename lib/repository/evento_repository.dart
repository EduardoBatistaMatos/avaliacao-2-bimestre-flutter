import '../models/evento.dart';

abstract class EventoRepository {
  Future<List<Evento>> listarTodos();
  Future<void> salvar(Evento evento);
  Future<void> atualizar(Evento evento);
  Future<void> deletar(int id);
}
