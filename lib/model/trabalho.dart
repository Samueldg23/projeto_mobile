class TrabalhoAcademico {
  final int? id;
  final String titulo;
  final String descricao;
  final String dataEntrega; 
  final String disciplina;
  final bool status;
  final int universitarioId;

  TrabalhoAcademico({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataEntrega,
    required this.disciplina,
    required this.status,
    required this.universitarioId,
  });

  factory TrabalhoAcademico.fromJson(Map<String, dynamic> json) {
    return TrabalhoAcademico(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataEntrega: json['dataEntrega'],
      disciplina: json['disciplina'],
      status: json['status'],
      universitarioId: json['universitario']['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataEntrega': dataEntrega,
      'disciplina': disciplina,
      'status': status,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataEntrega': dataEntrega,
      'disciplina': disciplina,
      'status': status ? 1 : 0,
      'universitarioId': universitarioId,
    };
  }

  factory TrabalhoAcademico.fromMap(Map<String, dynamic> map) {
    return TrabalhoAcademico(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      dataEntrega: map['dataEntrega'],
      disciplina: map['disciplina'],
      status: map['status'] == 1,
      universitarioId: map['universitarioId'],
    );
  }
}
