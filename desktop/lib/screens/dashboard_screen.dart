import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = FirebaseFirestore.instance;
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final [ordersSnap, productsSnap, usersSnap, pendingSnap] = await Future.wait([
      db.collection('orders').get(),
      db.collection('products').where('isActive', isEqualTo: true).get(),
      db.collection('users').get(),
      db.collection('orders').where('status', isEqualTo: 'pending').get(),
    ]);

    double todayRev = 0;
    for (final doc in ordersSnap.docs) {
      final data = doc.data();
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      if (createdAt != null && createdAt.isAfter(todayStart) && data['status'] == 'delivered') {
        todayRev += (data['grandTotal'] ?? 0).toDouble();
      }
    }

    setState(() {
      _totalOrders = ordersSnap.size;
      _pendingOrders = pendingSnap.size;
      _totalProducts = productsSnap.size;
      _totalUsers = usersSnap.size;
      _todayRevenue = todayRev;
      _loading = false;
    });
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
                  const Text('ড্যাশবোর্ড',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  _RecentOrdersTable(),
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
  final Map<String, String> _statusLabel = const {
    'pending': 'অপেক্ষমান',
    'confirmed': 'নিশ্চিত',
    'processing': 'প্রস্তুত',
    'shipped': 'পাঠানো',
    'delivered': 'পৌঁছেছে',
    'cancelled': 'বাতিল',
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
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
              ...docs.map((doc) {
                final d = doc.data() as Map<String, dynamic>;
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.all(12), child: Text(doc.id.substring(0, 8), style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'))),
                    Padding(padding: const EdgeInsets.all(12), child: Text(d['userName'] ?? '—', style: const TextStyle(color: Colors.white, fontSize: 13))),
                    Padding(padding: const EdgeInsets.all(12), child: Text('৳${d['grandTotal'] ?? 0}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                    Padding(padding: const EdgeInsets.all(12), child: Text(_statusLabel[d['status']] ?? d['status'] ?? '—', style: const TextStyle(color: Color(0xFFE95420), fontSize: 12))),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
