import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/universitario.dart';

class UniversitarioApi {
  static const String _baseUrl =
      'https://api-trabalhos-academicos.onrender.com/universitarios';

  static Future<Universitario?> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/login/$email/$senha');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Universitario.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<Universitario?> buscarPorId(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Universitario.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<Universitario> cadastrar(Universitario universitario) async {
    final url = Uri.parse('$_baseUrl/cadastrar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(universitario.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Universitario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao cadastrar universitário');
    }
  }

  static Future<void> atualizar(Universitario universitario) async {
    final url = Uri.parse('$_baseUrl/${universitario.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(universitario.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar universitário');
    }
  }

  static Future<void> excluir(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Falha ao excluir universitário');
    }
  }
}
