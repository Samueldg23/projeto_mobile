import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/trabalho.dart';

class TrabalhoApi {
  static const String _baseUrl = 'https://api-trabalhos-academicos.onrender.com/trabalhos';

  static Future<List<TrabalhoAcademico>> buscarPorUniversitario(int universitarioId) async {
    final url = Uri.parse('$_baseUrl/universitario/$universitarioId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TrabalhoAcademico.fromJson(json)).toList();
    } else {
      return [];
    }
  }
  static Future<TrabalhoAcademico?> buscarPorId(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return TrabalhoAcademico.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
  static Future<TrabalhoAcademico> cadastrar(TrabalhoAcademico trabalho) async {
    final url = Uri.parse('$_baseUrl/cadastrar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(trabalho.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TrabalhoAcademico.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao cadastrar trabalho');
    }
  }
  static Future<void> atualizar(TrabalhoAcademico trabalho) async {
    final url = Uri.parse('$_baseUrl/${trabalho.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(trabalho.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar trabalho');
    }
  }
  static Future<void> excluir(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir trabalho');
    }
  }
}
