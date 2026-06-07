import '../models/evento.dart';
import 'evento_repository.dart';
import 'evento_repository_local.dart';
import 'evento_repository_remoto.dart';

class EventoRepositoryComFallback implements EventoRepository {
  final EventoRepositoryRemoto _remoto = EventoRepositoryRemoto();
  final EventoRepositoryLocal _local = EventoRepositoryLocal();

  @override
  Future<List<Evento>> listarTodos() async {
    List<Evento> remotos = [];
    List<Evento> locais = [];

    try {
      remotos = await _remoto.listarTodos();
    } catch (_) {}

    try {
      locais = await _local.listarTodos();
    } catch (_) {}

    return [...remotos, ...locais];
  }

  @override
  Future<void> salvar(Evento evento) async {
    try {
      await _remoto.salvar(evento);
    } catch (_) {
      await _local.salvar(evento);
    }
  }

  @override
  Future<void> atualizar(Evento evento) async {
    try {
      await _remoto.atualizar(evento);
    } catch (_) {
      await _local.atualizar(evento);
    }
  }

  @override
  Future<void> deletar(int id) async {
    try {
      await _remoto.deletar(id);
    } catch (_) {
      await _local.deletar(id);
    }
  }
}
