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
      final data = await ApiService.get('/api/auth/me');
      _appUser = AppUser.fromMap(data, _firebaseUser!.uid);
    } catch (_) {}
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
