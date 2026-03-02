import 'dart:async';
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

  /// Returns `null` on success, or a Bengali error message on failure.
  static Future<String?> login(String email, String password) async {
    if (_apiKey.isEmpty) {
      return 'API কী কনফিগার করা হয়নি';
    }

    final http.Response res;
    try {
      res = await http
          .post(
            Uri.parse('$_firebaseAuthUrl?key=$_apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'password': password,
              'returnSecureToken': true,
            }),
          )
          .timeout(const Duration(seconds: 15));
    } on Exception {
      return 'সার্ভারের সাথে সংযোগ করা যাচ্ছে না';
    }

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      _idToken = data['idToken'];
      _userEmail = data['email'];
      return null;
    }

    // Parse Firebase error
    try {
      final body = json.decode(res.body);
      final code = body['error']?['message'] as String? ?? '';
      return _firebaseErrorToBangla(code);
    } catch (_) {
      return 'অজানা ত্রুটি (${res.statusCode})';
    }
  }

  static String _firebaseErrorToBangla(String code) {
    switch (code) {
      case 'EMAIL_NOT_FOUND':
        return 'এই ইমেইল দিয়ে কোনো অ্যাকাউন্ট নেই';
      case 'INVALID_PASSWORD':
        return 'পাসওয়ার্ড ভুল হয়েছে';
      case 'USER_DISABLED':
        return 'এই অ্যাকাউন্ট নিষ্ক্রিয় করা হয়েছে';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'ইমেইল বা পাসওয়ার্ড ভুল';
      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        return 'অনেক বার চেষ্টা হয়েছে, কিছুক্ষণ পর আবার চেষ্টা করুন';
      default:
        return 'লগইন ব্যর্থ: $code';
    }
  }

  static void logout() {
    _idToken = null;
    _userEmail = null;
  }
}
