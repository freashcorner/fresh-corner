import 'package:flutter/material.dart';
import '../../config/routes.dart';
import 'sidebar.dart';
import 'headerbar.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/monitoring/live_monitor_screen.dart';
import '../../screens/orders/orders_screen.dart';
import '../../screens/orders/dispatch_screen.dart';
import '../../screens/orders/returns_screen.dart';
import '../../screens/products/products_screen.dart';
import '../../screens/products/inventory_screen.dart';
import '../../screens/products/categories_screen.dart';
import '../../screens/users/customers_screen.dart';
import '../../screens/users/riders_screen.dart';
import '../../screens/users/vendors_screen.dart';
import '../../screens/users/staff_screen.dart';
import '../../screens/marketing/promos_screen.dart';
import '../../screens/marketing/notifications_screen.dart';
import '../../screens/marketing/banners_screen.dart';
import '../../screens/finance/finance_screen.dart';
import '../../screens/finance/payouts_screen.dart';
import '../../screens/analytics/analytics_screen.dart';
import '../../screens/analytics/reports_screen.dart';
import '../../screens/system/support_screen.dart';
import '../../screens/system/settings_screen.dart';
import '../../screens/system/activity_logs_screen.dart';

class AdminShell extends StatefulWidget {
  final VoidCallback onLogout;
  const AdminShell({super.key, required this.onLogout});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  PageId _activePage = PageId.dashboard;

  Widget _buildPage() {
    switch (_activePage) {
      case PageId.dashboard:
        return const DashboardScreen();
      case PageId.liveMonitor:
        return const LiveMonitorScreen();
      case PageId.orders:
        return const OrdersScreen();
      case PageId.dispatch:
        return const DispatchScreen();
      case PageId.returns:
        return const ReturnsScreen();
      case PageId.products:
        return const ProductsScreen();
      case PageId.inventory:
        return const InventoryScreen();
      case PageId.categories:
        return const CategoriesScreen();
      case PageId.customers:
        return const CustomersScreen();
      case PageId.riders:
        return const RidersScreen();
      case PageId.vendors:
        return const VendorsScreen();
      case PageId.staff:
        return const StaffScreen();
      case PageId.promos:
        return const PromosScreen();
      case PageId.notifications:
        return const NotificationsScreen();
      case PageId.banners:
        return const BannersScreen();
      case PageId.finance:
        return const FinanceScreen();
      case PageId.payouts:
        return const PayoutsScreen();
      case PageId.analytics:
        return const AnalyticsScreen();
      case PageId.reports:
        return const ReportsScreen();
      case PageId.support:
        return const SupportScreen();
      case PageId.settings:
        return const SettingsScreen();
      case PageId.activityLogs:
        return const ActivityLogsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            activePage: _activePage,
            onPageSelected: (id) => setState(() => _activePage = id),
            onLogout: widget.onLogout,
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFF3C3C3C)),
          Expanded(
            child: Column(
              children: [
                Headerbar(activePage: _activePage),
                Expanded(child: _buildPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
