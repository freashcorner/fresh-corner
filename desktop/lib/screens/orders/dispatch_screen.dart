import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../widgets/shared/status_badge.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});
  @override
  State<DispatchScreen> createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  final _orderIdCtrl = TextEditingController();
  final _riderIdCtrl = TextEditingController();
  final _riderNameCtrl = TextEditingController();
  final _riderPhoneCtrl = TextEditingController();
  final _etaCtrl = TextEditingController();
  bool _assigning = false;
  List<Map<String, dynamic>> _deliveries = [];
  bool _loading = true;

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
      setState(() { _deliveries = List<Map<String, dynamic>>.from(list); _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _assign() async {
    setState(() => _assigning = true);
    try {
      await ApiService.post('/api/delivery/assign', {
        'orderId': _orderIdCtrl.text, 'riderId': _riderIdCtrl.text,
        'riderName': _riderNameCtrl.text, 'riderPhone': _riderPhoneCtrl.text,
        'estimatedTime': _etaCtrl.text,
      });
      for (final c in [_orderIdCtrl, _riderIdCtrl, _riderNameCtrl, _riderPhoneCtrl, _etaCtrl]) c.clear();
      if (mounted) _loadDeliveries();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e')));
    } finally {
      setState(() => _assigning = false);
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    await ApiService.patch('/api/delivery/$id/status', {'status': status});
    _loadDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Assign panel
        SizedBox(
          width: 300,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('রাইডার নিযুক্ত করুন', style: TextStyle(color: YaruColors.text, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...[(_orderIdCtrl, 'অর্ডার আইডি'), (_riderIdCtrl, 'রাইডার আইডি'), (_riderNameCtrl, 'রাইডারের নাম'), (_riderPhoneCtrl, 'ফোন নম্বর'), (_etaCtrl, 'আনুমানিক সময়')]
                    .map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(controller: p.$1, style: const TextStyle(color: YaruColors.text, fontSize: 13), decoration: InputDecoration(hintText: p.$2)),
                )),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _assigning ? null : _assign,
                    child: _assigning ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('নিযুক্ত করুন'),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Delivery list
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: YaruColors.orange))
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 24, 24, 24),
                  child: Container(
                    decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                        columns: const [
                          DataColumn(label: Text('অর্ডার', style: TextStyle(color: YaruColors.text2))),
                          DataColumn(label: Text('রাইডার', style: TextStyle(color: YaruColors.text2))),
                          DataColumn(label: Text('সময়', style: TextStyle(color: YaruColors.text2))),
                          DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                          DataColumn(label: Text('পরিবর্তন', style: TextStyle(color: YaruColors.text2))),
                        ],
                        rows: _deliveries.map((d) {
                          final id = (d['_id'] ?? d['id'] ?? '').toString();
                          final orderId = (d['orderId'] ?? '').toString();
                          return DataRow(cells: [
                            DataCell(Text(orderId.length >= 8 ? orderId.substring(0, 8) : orderId, style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                            DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(d['riderName'] ?? '—', style: const TextStyle(color: YaruColors.text, fontSize: 13)),
                              Text(d['riderPhone'] ?? '', style: const TextStyle(color: YaruColors.text3, fontSize: 11)),
                            ])),
                            DataCell(Text(d['estimatedTime'] ?? '—', style: const TextStyle(color: YaruColors.text2))),
                            DataCell(StatusBadge.fromStatus(d['status'] ?? 'assigned')),
                            DataCell(DropdownButton<String>(
                              value: d['status'] ?? 'assigned',
                              dropdownColor: YaruColors.bg3,
                              style: const TextStyle(color: YaruColors.text, fontSize: 12),
                              underline: const SizedBox(), isDense: true,
                              items: ['assigned', 'picked', 'on_way', 'delivered'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
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
