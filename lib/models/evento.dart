class Evento {
  int? id;
  String nome;
  String local;
  String data;

  Evento({
    this.id,
    required this.nome,
    required this.local,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'local': local,
      'data': data,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      local: map['local'] as String,
      data: map['data'] as String,
    );
  }
}
