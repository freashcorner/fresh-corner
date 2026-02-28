import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final _orderIdCtrl = TextEditingController();
  final _riderIdCtrl = TextEditingController();
  final _riderNameCtrl = TextEditingController();
  final _riderPhoneCtrl = TextEditingController();
  final _etaCtrl = TextEditingController();
  bool _assigning = false;
  List<Map<String, dynamic>> _deliveries = [];
  bool _loading = true;

  static const Map<String, String> STATUS_LABEL = {
    'assigned': 'নিযুক্ত',
    'picked': 'নেওয়া হয়েছে',
    'on_way': 'পথে আছে',
    'delivered': 'পৌঁছে গেছে',
  };

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.get('/api/delivery');
      final list = (res is List) ? res : (res['deliveries'] ?? []) as List;
      setState(() {
        _deliveries = List<Map<String, dynamic>>.from(list);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _assign() async {
    setState(() => _assigning = true);
    try {
      await ApiService.post('/api/delivery/assign', {
        'orderId': _orderIdCtrl.text,
        'riderId': _riderIdCtrl.text,
        'riderName': _riderNameCtrl.text,
        'riderPhone': _riderPhoneCtrl.text,
        'estimatedTime': _etaCtrl.text,
      });
      _orderIdCtrl.clear(); _riderIdCtrl.clear(); _riderNameCtrl.clear(); _riderPhoneCtrl.clear(); _etaCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('রাইডার নিযুক্ত হয়েছে')));
        _loadDeliveries();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e')));
    } finally {
      setState(() => _assigning = false);
    }
  }

  Future<void> _updateStatus(String deliveryId, String status) async {
    await ApiService.patch('/api/delivery/$deliveryId/status', {'status': status});
    _loadDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Row(
        children: [
          // Assign Panel
          SizedBox(
            width: 320,
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('রাইডার নিযুক্ত করুন',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  ...[
                    (_orderIdCtrl, 'অর্ডার আইডি'),
                    (_riderIdCtrl, 'রাইডার আইডি'),
                    (_riderNameCtrl, 'রাইডারের নাম'),
                    (_riderPhoneCtrl, 'ফোন নম্বর'),
                    (_etaCtrl, 'আনুমানিক সময়'),
                  ].map((pair) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: pair.$1,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: pair.$2,
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFF3C3C3C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE95420)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _assigning ? null : _assign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE95420),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _assigning
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text('নিযুক্ত করুন', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Deliveries List
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 24, 16),
                  child: Row(
                    children: [
                      const Text('ডেলিভারি তালিকা',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white38),
                        onPressed: _loadDeliveries,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFE95420)))
                      : _deliveries.isEmpty
                          ? const Center(child: Text('কোনো ডেলিভারি নেই', style: TextStyle(color: Colors.white38)))
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D2D2D),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                                ),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                                  columns: const [
                                    DataColumn(label: Text('অর্ডার', style: TextStyle(color: Colors.white54))),
                                    DataColumn(label: Text('রাইডার', style: TextStyle(color: Colors.white54))),
                                    DataColumn(label: Text('আনুমানিক সময়', style: TextStyle(color: Colors.white54))),
                                    DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: Colors.white54))),
                                  ],
                                  rows: _deliveries.map((d) {
                                    final id = (d['_id'] ?? d['id'] ?? '').toString();
                                    final orderId = (d['orderId'] ?? '').toString();
                                    return DataRow(cells: [
                                      DataCell(Text(orderId.length >= 8 ? orderId.substring(0, 8) : orderId,
                                          style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'monospace'))),
                                      DataCell(Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(d['riderName'] ?? '—', style: const TextStyle(color: Colors.white, fontSize: 13)),
                                          Text(d['riderPhone'] ?? '', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                        ],
                                      )),
                                      DataCell(Text(d['estimatedTime'] ?? '—', style: const TextStyle(color: Colors.white54))),
                                      DataCell(DropdownButton<String>(
                                        value: d['status'] ?? 'assigned',
                                        dropdownColor: const Color(0xFF3C3C3C),
                                        style: const TextStyle(color: Colors.white, fontSize: 13),
                                        underline: const SizedBox(),
                                        items: STATUS_LABEL.entries.map((e) =>
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
          ),
        ],
      ),
    );
  }
}
