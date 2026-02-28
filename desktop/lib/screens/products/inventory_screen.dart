import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../widgets/shared/stat_card.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.get('/api/products');
      final list = (res is List) ? res : (res['products'] ?? []) as List;
      setState(() { _products = List<Map<String, dynamic>>.from(list); _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowStock = _products.where((p) => (p['stock'] ?? 0) < 10).length;
    final outOfStock = _products.where((p) => (p['stock'] ?? 0) == 0).length;

    return _loading
        ? const Center(child: CircularProgressIndicator(color: YaruColors.orange))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(spacing: 14, runSpacing: 14, children: [
                  StatCard(label: 'মোট পণ্য', value: '${_products.length}', accentColor: YaruColors.blue),
                  StatCard(label: 'স্টক কম', value: '$lowStock', accentColor: YaruColors.yellow),
                  StatCard(label: 'স্টক শেষ', value: '$outOfStock', accentColor: YaruColors.red),
                ]),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                      columns: const [
                        DataColumn(label: Text('পণ্য', style: TextStyle(color: YaruColors.text2))),
                        DataColumn(label: Text('স্টক', style: TextStyle(color: YaruColors.text2)), numeric: true),
                        DataColumn(label: Text('ইউনিট', style: TextStyle(color: YaruColors.text2))),
                        DataColumn(label: Text('মূল্য', style: TextStyle(color: YaruColors.text2)), numeric: true),
                        DataColumn(label: Text('অবস্থা', style: TextStyle(color: YaruColors.text2))),
                      ],
                      rows: _products.map((d) {
                        final stock = d['stock'] ?? 0;
                        final status = stock == 0 ? 'স্টক শেষ' : stock < 10 ? 'স্টক কম' : 'পর্যাপ্ত';
                        final statusColor = stock == 0 ? YaruColors.red : stock < 10 ? YaruColors.yellow : YaruColors.green;
                        return DataRow(cells: [
                          DataCell(Text(d['name'] ?? '—', style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                          DataCell(Text('$stock', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold))),
                          DataCell(Text(d['unit'] ?? '—', style: const TextStyle(color: YaruColors.text2))),
                          DataCell(Text('৳${d['price'] ?? 0}', style: const TextStyle(color: YaruColors.text))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                            child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                          )),
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
