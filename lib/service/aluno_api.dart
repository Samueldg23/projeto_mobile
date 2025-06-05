import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/aluno.dart';

class AlunoApi {
  static const String _baseUrl = 'https://api-trabalhos-academicos.onrender.com/alunos';

  static Future<Aluno?> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return Aluno.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<Aluno?> cadastrar(Aluno aluno) async {
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(aluno.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Aluno.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
