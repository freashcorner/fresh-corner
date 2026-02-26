import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  static const Map<String, String> STATUS_LABEL = {
    'assigned': 'নিযুক্ত',
    'picked': 'নেওয়া হয়েছে',
    'on_way': 'পথে আছে',
    'delivered': 'পৌঁছে গেছে',
  };

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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('রাইডার নিযুক্ত হয়েছে')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ত্রুটি: $e')));
    } finally {
      setState(() => _assigning = false);
    }
  }

  Future<void> _updateStatus(String orderId, String status) async {
    await ApiService.patch('/api/delivery/$orderId/status', {'status': status});
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 24, 24, 16),
                  child: Text('ডেলিভারি তালিকা',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('deliveries')
                        .orderBy('assignedAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFE95420)));
                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) return const Center(child: Text('কোনো ডেলিভারি নেই', style: TextStyle(color: Colors.white38)));

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(0, 0, 24, 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2D2D),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.white.withOpacity(0.04)),
                            columns: const [
                              DataColumn(label: Text('অর্ডার', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('রাইডার', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('আনুমানিক সময়', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: Colors.white54))),
                            ],
                            rows: docs.map((doc) {
                              final d = doc.data() as Map<String, dynamic>;
                              return DataRow(cells: [
                                DataCell(Text(d['orderId']?.toString().substring(0, 8) ?? '—',
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
                                  onChanged: (val) { if (val != null) _updateStatus(doc.id, val); },
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      );
                    },
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
