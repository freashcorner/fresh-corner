import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _firebaseAuthUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';

  static const String _apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static String? _idToken;
  static String? _userEmail;

  static String? get token => _idToken;
  static String? get email => _userEmail;
  static bool get isLoggedIn => _idToken != null;

  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_firebaseAuthUrl?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      _idToken = data['idToken'];
      _userEmail = data['email'];
      return true;
    }
    return false;
  }

  static void logout() {
    _idToken = null;
    _userEmail = null;
  }
}
