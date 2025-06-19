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
}
