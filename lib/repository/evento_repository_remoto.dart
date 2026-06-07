import '../models/evento.dart';
import '../services/evento_service.dart';
import 'evento_repository.dart';

class EventoRepositoryRemoto implements EventoRepository {
  final EventoService _service = EventoService();

  @override
  Future<List<Evento>> listarTodos() => _service.listarTodos();

  @override
  Future<void> salvar(Evento evento) => _service.salvar(evento);

  @override
  Future<void> atualizar(Evento evento) => _service.atualizar(evento);

  @override
  Future<void> deletar(int id) => _service.deletar(id);
}
