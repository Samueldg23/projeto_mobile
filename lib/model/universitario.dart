class Universitario {
  final int? id;
  final String nome;
  final String email;
  final String senha;

  Universitario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory Universitario.fromJson(Map<String, dynamic> json) {
    return Universitario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  Map<String, dynamic> toMap() => toJson();

  factory Universitario.fromMap(Map<String, dynamic> map) => Universitario.fromJson(map);
}
