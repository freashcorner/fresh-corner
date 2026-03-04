import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _firebaseUser;
  AppUser? _appUser;
  bool _loading = true;

  User? get firebaseUser => _firebaseUser;
  AppUser? get appUser => _appUser;
  bool get loading => _loading;
  bool get isLoggedIn => _firebaseUser != null;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        await _fetchAppUser();
      } else {
        _appUser = null;
      }
      _loading = false;
      notifyListeners();
    });
  }

  Future<void> _fetchAppUser() async {
    try {
      // Set timeout for API call (10 seconds)
      final data = await ApiService.get('/api/auth/me').timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('API request timeout');
        },
      );
      _appUser = AppUser.fromMap(data, _firebaseUser!.uid);
    } catch (e) {
      debugPrint('Failed to fetch app user: $e');
      // Still allow login even if profile fetch fails
      _appUser = null;
    }
  }

  Future<void> register(String name, String phone) async {
    await ApiService.post('/api/auth/register', {'name': name, 'phone': phone});
    await _fetchAppUser();
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
