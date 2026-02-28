import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../widgets/shared/tab_bar_pills.dart';
import '../../widgets/shared/search_field.dart';
import '../../widgets/shared/status_badge.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _tabIndex = 0;
  String _search = '';
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;

  static const _statuses = ['', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
  static const _tabLabels = ['সব', 'অপেক্ষমান', 'নিশ্চিত', 'প্রস্তুত', 'পাঠানো', 'পৌঁছেছে', 'বাতিল'];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    try {
      final status = _statuses[_tabIndex];
      final path = status.isEmpty ? '/api/orders' : '/api/orders?status=$status';
      final res = await ApiService.get(path);
      final list = (res is List) ? res : (res['orders'] ?? []) as List;
      setState(() { _orders = List<Map<String, dynamic>>.from(list); _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateStatus(String orderId, String status) async {
    await ApiService.patch('/api/orders/$orderId/status', {'status': status});
    if (mounted) _loadOrders();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_search.isEmpty) return _orders;
    final q = _search.toLowerCase();
    return _orders.where((o) =>
      (o['userName'] ?? '').toString().toLowerCase().contains(q) ||
      (o['_id'] ?? o['id'] ?? '').toString().toLowerCase().contains(q) ||
      (o['userPhone'] ?? '').toString().contains(q)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            children: [
              Expanded(child: TabBarPills(tabs: _tabLabels, selected: _tabIndex, onSelected: (i) { setState(() => _tabIndex = i); _loadOrders(); })),
              const SizedBox(width: 12),
              SearchField(onChanged: (v) => setState(() => _search = v)),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: YaruColors.orange))
              : filtered.isEmpty
                  ? const Center(child: Text('কোনো অর্ডার নেই', style: TextStyle(color: YaruColors.text3)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Container(
                        decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                            columns: const [
                              DataColumn(label: Text('আইডি', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('গ্রাহক', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('আইটেম', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('মোট', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('পেমেন্ট', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('অ্যাকশন', style: TextStyle(color: YaruColors.text2))),
                            ],
                            rows: filtered.map((d) {
                              final id = (d['_id'] ?? d['id'] ?? '').toString();
                              final items = (d['items'] as List?)?.length ?? 0;
                              return DataRow(cells: [
                                DataCell(Text(id.length >= 8 ? id.substring(0, 8) : id, style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                                DataCell(Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(d['userName'] ?? '—', style: const TextStyle(color: YaruColors.text, fontSize: 13)),
                                    Text(d['userPhone'] ?? '', style: const TextStyle(color: YaruColors.text3, fontSize: 11)),
                                  ],
                                )),
                                DataCell(Text('$items টি', style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                                DataCell(Text('৳${d['grandTotal'] ?? 0}', style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                                DataCell(Text('${d['paymentMethod']?.toString().toUpperCase() ?? 'COD'}', style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                                DataCell(StatusBadge.fromStatus(d['status'] ?? 'pending')),
                                DataCell(DropdownButton<String>(
                                  value: d['status'] ?? 'pending',
                                  dropdownColor: YaruColors.bg3,
                                  style: const TextStyle(color: YaruColors.text, fontSize: 12),
                                  underline: const SizedBox(),
                                  isDense: true,
                                  items: _statuses.skip(1).map((s) => DropdownMenuItem(value: s, child: Text(_tabLabels[_statuses.indexOf(s)]))).toList(),
                                  onChanged: (val) { if (val != null) _updateStatus(id, val); },
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
