import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'widgets/shell/admin_shell.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FreshCornerDesktopApp());
}

class FreshCornerDesktopApp extends StatefulWidget {
  const FreshCornerDesktopApp({super.key});

  @override
  State<FreshCornerDesktopApp> createState() => _FreshCornerDesktopAppState();
}

class _FreshCornerDesktopAppState extends State<FreshCornerDesktopApp> {
  bool _loggedIn = AuthService.isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ফ্রেশ কর্নার — Admin',
      debugShowCheckedModeBanner: false,
      theme: buildYaruTheme(),
      home: _loggedIn
          ? AdminShell(onLogout: () => setState(() { AuthService.logout(); _loggedIn = false; }))
          : LoginScreen(onLoginSuccess: () => setState(() => _loggedIn = true)),
    );
  }
}
