import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://fresh-corner-api.onrender.com',
  );

  static Map<String, String> _headers() {
    final token = AuthService.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String path) async {
    final res = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
    );
    if (res.statusCode < 300) return json.decode(utf8.decode(res.bodyBytes));
    throw Exception('API Error ${res.statusCode}');
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: json.encode(body),
    );
    if (res.statusCode < 300) return json.decode(utf8.decode(res.bodyBytes));
    throw Exception('API Error ${res.statusCode}');
  }

  static Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers(),
      body: json.encode(body),
    );
    if (res.statusCode < 300) return json.decode(utf8.decode(res.bodyBytes));
    throw Exception('API Error ${res.statusCode}');
  }
}
