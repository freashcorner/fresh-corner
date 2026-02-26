import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';
import 'screens/delivery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FreshCornerDesktopApp());
}

class FreshCornerDesktopApp extends StatelessWidget {
  const FreshCornerDesktopApp({super.key});

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
      home: const AdminShell(),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

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
            destinations: _navItems,
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFF3C3C3C)),
          Expanded(child: _pages[_page]),
        ],
      ),
    );
  }
}
