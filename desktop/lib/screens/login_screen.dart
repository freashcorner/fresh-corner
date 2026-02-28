import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      final ok = await AuthService.login(_emailCtrl.text.trim(), _passCtrl.text);
      if (ok) {
        widget.onLoginSuccess();
      } else {
        setState(() => _error = 'ইমেইল বা পাসওয়ার্ড ভুল');
      }
    } catch (e) {
      setState(() => _error = 'লগইন ত্রুটি: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YaruColors.bg,
      body: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: YaruColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: YaruColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A4731), Color(0xFF2ECC71)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.eco, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              const Text('ফ্রেশ কর্নার', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71))),
              const SizedBox(height: 4),
              const Text('Admin Panel', style: TextStyle(fontSize: 12, color: YaruColors.text3)),
              const SizedBox(height: 24),
              TextField(
                controller: _emailCtrl,
                style: const TextStyle(color: YaruColors.text),
                decoration: const InputDecoration(
                  hintText: 'ইমেইল',
                  prefixIcon: Icon(Icons.email_outlined, color: YaruColors.text3),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                style: const TextStyle(color: YaruColors.text),
                onSubmitted: (_) => _login(),
                decoration: const InputDecoration(
                  hintText: 'পাসওয়ার্ড',
                  prefixIcon: Icon(Icons.lock_outline, color: YaruColors.text3),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: YaruColors.red, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('লগইন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
