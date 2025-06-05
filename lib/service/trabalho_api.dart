import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/trabalho.dart';

class TrabalhoApi {
  static const String _baseUrl = 'https://api-trabalhos-academicos.onrender.com/trabalhos';

  static Future<List<TrabalhoAcademico>> buscarPorAluno(int alunoId) async {
    final url = Uri.parse('$_baseUrl/aluno/$alunoId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TrabalhoAcademico.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<bool> criar(TrabalhoAcademico trabalho) async {
    final url = Uri.parse('$_baseUrl/${trabalho.alunoId}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(trabalho.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> atualizar(TrabalhoAcademico trabalho) async {
    final url = Uri.parse('$_baseUrl/${trabalho.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(trabalho.toJson()),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deletar(int trabalhoId) async {
    final url = Uri.parse('$_baseUrl/$trabalhoId');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }
}
