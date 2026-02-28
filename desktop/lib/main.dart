import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';
import 'screens/delivery_screen.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          surface: const Color(0xFF2D2D2D),
          background: const Color(0xFF1C1C1C),
          primary: const Color(0xFFE95420),
        ),
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
        useMaterial3: true,
      ),
      home: _loggedIn
          ? AdminShell(onLogout: () => setState(() { AuthService.logout(); _loggedIn = false; }))
          : LoginScreen(onLoginSuccess: () => setState(() => _loggedIn = true)),
    );
  }
}

class AdminShell extends StatefulWidget {
  final VoidCallback onLogout;
  const AdminShell({super.key, required this.onLogout});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _page = 0;

  final _pages = const [
    DashboardScreen(),
    OrdersScreen(),
    ProductsScreen(),
    DeliveryScreen(),
  ];

  final _navItems = const [
    NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('ড্যাশবোর্ড')),
    NavigationRailDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: Text('অর্ডার')),
    NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: Text('পণ্য')),
    NavigationRailDestination(icon: Icon(Icons.delivery_dining_outlined), selectedIcon: Icon(Icons.delivery_dining), label: Text('ডেলিভারি')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _page,
            onDestinationSelected: (i) => setState(() => _page = i),
            labelType: NavigationRailLabelType.all,
            backgroundColor: const Color(0xFF252525),
            indicatorColor: const Color(0xFFE95420).withOpacity(0.2),
            selectedIconTheme: const IconThemeData(color: Color(0xFFE95420)),
            selectedLabelTextStyle: const TextStyle(color: Color(0xFFE95420)),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: const Color(0xFFE95420), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.storefront, color: Colors.white, size: 22),
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white38),
                    tooltip: 'লগআউট',
                    onPressed: widget.onLogout,
                  ),
                ),
              ),
            ),
            destinations: _navItems,
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFF3C3C3C)),
          Expanded(child: _pages[_page]),
        ],
      ),
    );
  }
}
