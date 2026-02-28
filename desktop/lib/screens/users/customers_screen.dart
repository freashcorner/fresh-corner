import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';


class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Map<String, dynamic>> _customers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.get('/api/users');
      final list = (res is List) ? res : (res['users'] ?? []) as List;
      // Merge with mock tier data
      final mockCustomers = MockDataService.customers();
      final customers = List<Map<String, dynamic>>.from(list);
      for (var i = 0; i < customers.length; i++) {
        final mock = i < mockCustomers.length ? mockCustomers[i] : {};
        customers[i]['tier'] = mock['tier'] ?? 'New';
        customers[i]['area'] = mock['area'] ?? '—';
      }
      setState(() { _customers = customers; _loading = false; });
    } catch (e) {
      setState(() { _customers = MockDataService.customers(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator(color: YaruColors.orange))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(spacing: 14, runSpacing: 14, children: [
                  StatCard(label: 'মোট কাস্টমার', value: '${_customers.length}', accentColor: YaruColors.blue),
                  StatCard(label: 'প্রিমিয়াম', value: '${_customers.where((c) => c['tier'] == 'Premium').length}', accentColor: YaruColors.purple),
                ]),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                      columns: const [
                        DataColumn(label: Text('নাম', style: TextStyle(color: YaruColors.text2))),
                        DataColumn(label: Text('ফোন', style: TextStyle(color: YaruColors.text2))),
                        DataColumn(label: Text('এলাকা', style: TextStyle(color: YaruColors.text2))),
                        DataColumn(label: Text('টিয়ার', style: TextStyle(color: YaruColors.text2))),
                      ],
                      rows: _customers.map((d) {
                        final name = d['name'] ?? d['userName'] ?? '—';
                        final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
                        return DataRow(cells: [
                          DataCell(Row(children: [
                            Container(
                              width: 30, height: 30,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(colors: [Color(0xFF5E2750), Color(0xFF9141AC)])),
                              child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                            ),
                            const SizedBox(width: 10),
                            Text(name, style: const TextStyle(color: YaruColors.text, fontSize: 13)),
                          ])),
                          DataCell(Text(d['phone'] ?? d['userPhone'] ?? '—', style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                          DataCell(Text(d['area'] ?? '—', style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                          DataCell(_tierBadge(d['tier'] ?? 'New')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _tierBadge(String tier) {
    final color = tier == 'Premium' ? YaruColors.purple : tier == 'Regular' ? YaruColors.blue : YaruColors.text3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
      child: Text(tier, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
