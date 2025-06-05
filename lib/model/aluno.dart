class Aluno {
  final int? id;
  final String nome;
  final String email;
  final String senha;

  Aluno({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // Para API → converte JSON em objeto
  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  // Para API → converte objeto em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  // Para SQLite → converte objeto em Map
  Map<String, dynamic> toMap() => toJson();

  // Para SQLite → converte Map em objeto
  factory Aluno.fromMap(Map<String, dynamic> map) => Aluno.fromJson(map);
}
