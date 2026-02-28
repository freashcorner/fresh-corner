import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _filterStatus = '';
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;

  static const Map<String, String> STATUS_LABEL = {
    '': 'সব',
    'pending': 'অপেক্ষমান',
    'confirmed': 'নিশ্চিত',
    'processing': 'প্রস্তুত',
    'shipped': 'পাঠানো',
    'delivered': 'পৌঁছেছে',
    'cancelled': 'বাতিল',
  };

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    try {
      final path = _filterStatus.isEmpty
          ? '/api/orders'
          : '/api/orders?status=$_filterStatus';
      final res = await ApiService.get(path);
      final list = (res is List) ? res : (res['orders'] ?? []) as List;
      setState(() {
        _orders = List<Map<String, dynamic>>.from(list);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateStatus(String orderId, String status) async {
    await ApiService.patch('/api/orders/$orderId/status', {'status': status});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('স্ট্যাটাস আপডেট হয়েছে')));
      _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Text('অর্ডার', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white38),
                  onPressed: _loadOrders,
                ),
                const Spacer(),
                Wrap(
                  spacing: 8,
                  children: STATUS_LABEL.entries.map((e) => ChoiceChip(
                    label: Text(e.value, style: TextStyle(fontSize: 12, color: _filterStatus == e.key ? Colors.white : Colors.white54)),
                    selected: _filterStatus == e.key,
                    selectedColor: const Color(0xFFE95420),
                    backgroundColor: const Color(0xFF3C3C3C),
                    onSelected: (_) {
                      setState(() => _filterStatus = e.key);
                      _loadOrders();
                    },
                  )).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE95420)))
                : _orders.isEmpty
                    ? const Center(child: Text('কোনো অর্ডার নেই', style: TextStyle(color: Colors.white38)))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2D2D),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                            columns: const [
                              DataColumn(label: Text('আইডি', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('গ্রাহক', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('মোট', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('পেমেন্ট', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('স্ট্যাটাস পরিবর্তন', style: TextStyle(color: Colors.white54))),
                            ],
                            rows: _orders.map((d) {
                              final id = (d['_id'] ?? d['id'] ?? '').toString();
                              return DataRow(cells: [
                                DataCell(Text(id.length >= 8 ? id.substring(0, 8) : id, style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'))),
                                DataCell(Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(d['userName'] ?? '—', style: const TextStyle(color: Colors.white, fontSize: 13)),
                                    Text(d['userPhone'] ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                  ],
                                )),
                                DataCell(Text('৳${d['grandTotal'] ?? 0}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                DataCell(Text('${d['paymentMethod']?.toString().toUpperCase() ?? 'COD'}', style: const TextStyle(color: Colors.white54, fontSize: 12))),
                                DataCell(DropdownButton<String>(
                                  value: d['status'] ?? 'pending',
                                  dropdownColor: const Color(0xFF3C3C3C),
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  underline: const SizedBox(),
                                  items: STATUS_LABEL.entries.skip(1).map((e) =>
                                    DropdownMenuItem(value: e.key, child: Text(e.value))
                                  ).toList(),
                                  onChanged: (val) { if (val != null) _updateStatus(id, val); },
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
