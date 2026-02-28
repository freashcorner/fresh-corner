import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/section_header.dart';
import '../../widgets/shared/status_badge.dart';
import '../../widgets/shared/bar_chart.dart';
import '../../widgets/shared/donut_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalOrders = 0, _pendingOrders = 0, _totalProducts = 0, _totalUsers = 0;
  double _todayRevenue = 0;
  int _activeOrders = 0, _onlineRiders = 0;
  double _cancelRate = 0;
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
      int pending = 0, active = 0, cancelled = 0;

      for (final o in orders) {
        final s = o['status'] ?? '';
        if (s == 'pending') pending++;
        if (s == 'cancelled') cancelled++;
        if (s == 'pending' || s == 'confirmed' || s == 'processing' || s == 'shipped') active++;
        final createdAt = DateTime.tryParse(o['createdAt']?.toString() ?? '');
        if (createdAt != null && createdAt.isAfter(todayStart) && s == 'delivered') {
          todayRev += (o['grandTotal'] ?? 0).toDouble();
        }
      }

      final sorted = List<Map<String, dynamic>>.from(orders);
      sorted.sort((a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''));

      setState(() {
        _totalOrders = orders.length;
        _pendingOrders = pending;
        _totalProducts = products.length;
        _totalUsers = users.length;
        _todayRevenue = todayRev;
        _activeOrders = active;
        _onlineRiders = 8;
        _cancelRate = orders.isEmpty ? 0 : (cancelled / orders.length * 100);
        _recentOrders = sorted.take(8).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: YaruColors.orange));

    final analytics = MockDataService.analyticsSummary();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alerts
          if (_pendingOrders > 3)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: YaruColors.yellow.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.yellow.withOpacity(0.3))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: YaruColors.yellow, size: 18),
                const SizedBox(width: 10),
                Text('$_pendingOrders টি অর্ডার অপেক্ষমান!', style: const TextStyle(color: YaruColors.yellow, fontSize: 13)),
              ]),
            ),
          // KPI Cards
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              StatCard(label: 'আজকের আয়', value: '৳${_todayRevenue.toInt()}', accentColor: YaruColors.green, change: '+12%', sparkline: [3, 5, 4, 7, 6, 8, 9]),
              StatCard(label: 'মোট অর্ডার', value: '$_totalOrders', accentColor: YaruColors.blue, change: '+8%', sparkline: [10, 12, 11, 15, 14, 16, 18]),
              StatCard(label: 'গড় ডেলিভারি', value: '32m', accentColor: YaruColors.orange, change: '-5%', positive: false),
              StatCard(label: 'নতুন কাস্টমার', value: '$_totalUsers', accentColor: YaruColors.purple, change: '+15%'),
              StatCard(label: 'সক্রিয় অর্ডার', value: '$_activeOrders', accentColor: YaruColors.cyan),
              StatCard(label: 'অনলাইন রাইডার', value: '$_onlineRiders', accentColor: YaruColors.green),
              StatCard(label: 'বাতিল হার', value: '${_cancelRate.toStringAsFixed(1)}%', accentColor: YaruColors.red),
              StatCard(label: 'মোট পণ্য', value: '$_totalProducts', accentColor: YaruColors.yellow),
            ],
          ),
          const SizedBox(height: 28),
          // Charts row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('সাপ্তাহিক আয়', style: TextStyle(color: YaruColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      SimpleBarChart(
                        data: (analytics['dailyRevenue'] as List).map((e) => BarChartData((e as BarChartEntry).label, e.value)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('বিক্রয় ভাগ', style: TextStyle(color: YaruColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      DonutChart(
                        data: (analytics['categoryBreakdown'] as List).map((e) {
                          final d = e as DonutEntry;
                          return DonutChartData(d.label, d.value, Color(d.colorValue));
                        }).toList(),
                        size: 130,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Recent orders
          const SectionHeader(title: 'সাম্প্রতিক অর্ডার'),
          Container(
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                columns: const [
                  DataColumn(label: Text('আইডি', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('গ্রাহক', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('মোট', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                ],
                rows: _recentOrders.map((d) {
                  final id = (d['_id'] ?? d['id'] ?? '').toString();
                  return DataRow(cells: [
                    DataCell(Text(id.length >= 8 ? id.substring(0, 8) : id, style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                    DataCell(Text(d['userName'] ?? '—', style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                    DataCell(Text('৳${d['grandTotal'] ?? 0}', style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold, fontSize: 13))),
                    DataCell(StatusBadge.fromStatus(d['status'] ?? 'pending')),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
