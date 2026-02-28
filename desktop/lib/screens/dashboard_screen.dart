import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalOrders = 0;
  int _pendingOrders = 0;
  int _totalProducts = 0;
  int _totalUsers = 0;
  double _todayRevenue = 0;
  bool _loading = true;
  List<Map<String, dynamic>> _recentOrders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ApiService.get('/api/orders'),
        ApiService.get('/api/products'),
        ApiService.get('/api/users'),
      ]);

      final orders = (results[0] is List) ? results[0] as List : (results[0]['orders'] ?? []) as List;
      final products = (results[1] is List) ? results[1] as List : (results[1]['products'] ?? []) as List;
      final users = (results[2] is List) ? results[2] as List : (results[2]['users'] ?? []) as List;

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      double todayRev = 0;
      int pending = 0;

      for (final o in orders) {
        if (o['status'] == 'pending') pending++;
        final createdAt = DateTime.tryParse(o['createdAt']?.toString() ?? '');
        if (createdAt != null && createdAt.isAfter(todayStart) && o['status'] == 'delivered') {
          todayRev += (o['grandTotal'] ?? 0).toDouble();
        }
      }

      // Sort by createdAt descending, take 10
      final sorted = List<Map<String, dynamic>>.from(orders);
      sorted.sort((a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''));
      final recent = sorted.take(10).toList();

      setState(() {
        _totalOrders = orders.length;
        _pendingOrders = pending;
        _totalProducts = products.length;
        _totalUsers = users.length;
        _todayRevenue = todayRev;
        _recentOrders = recent;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE95420)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('ড্যাশবোর্ড',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white38),
                        onPressed: () { setState(() => _loading = true); _load(); },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _StatCard(label: 'মোট অর্ডার', value: '$_totalOrders', icon: Icons.receipt_long, color: Colors.blue),
                      _StatCard(label: 'অপেক্ষমান', value: '$_pendingOrders', icon: Icons.hourglass_empty, color: Colors.orange),
                      _StatCard(label: 'মোট পণ্য', value: '$_totalProducts', icon: Icons.inventory_2, color: const Color(0xFF26A269)),
                      _StatCard(label: 'ব্যবহারকারী', value: '$_totalUsers', icon: Icons.people, color: Colors.purple),
                      _StatCard(label: 'আজকের আয়', value: '৳${_todayRevenue.toInt()}', icon: Icons.trending_up, color: const Color(0xFFE95420)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('সাম্প্রতিক অর্ডার',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  _RecentOrdersTable(orders: _recentOrders),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
        ],
      ),
    );
  }
}

class _RecentOrdersTable extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const _RecentOrdersTable({required this.orders});

  static const Map<String, String> _statusLabel = {
    'pending': 'অপেক্ষমান',
    'confirmed': 'নিশ্চিত',
    'processing': 'প্রস্তুত',
    'shipped': 'পাঠানো',
    'delivered': 'পৌঁছেছে',
    'cancelled': 'বাতিল',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            children: ['আইডি', 'গ্রাহক', 'মোট', 'স্ট্যাটাস'].map((h) => Padding(
              padding: const EdgeInsets.all(12),
              child: Text(h, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w600)),
            )).toList(),
          ),
          ...orders.map((d) {
            final id = (d['_id'] ?? d['id'] ?? '').toString();
            return TableRow(
              children: [
                Padding(padding: const EdgeInsets.all(12), child: Text(id.length >= 8 ? id.substring(0, 8) : id, style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'))),
                Padding(padding: const EdgeInsets.all(12), child: Text(d['userName'] ?? '—', style: const TextStyle(color: Colors.white, fontSize: 13))),
                Padding(padding: const EdgeInsets.all(12), child: Text('৳${d['grandTotal'] ?? 0}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                Padding(padding: const EdgeInsets.all(12), child: Text(_statusLabel[d['status']] ?? d['status'] ?? '—', style: const TextStyle(color: Color(0xFFE95420), fontSize: 12))),
              ],
            );
          }),
        ],
      ),
    );
  }
}
