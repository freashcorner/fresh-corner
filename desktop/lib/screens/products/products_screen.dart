import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';
import '../../widgets/shared/search_field.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  String _search = '';

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

  List<Map<String, dynamic>> get _filtered {
    if (_search.isEmpty) return _products;
    final q = _search.toLowerCase();
    return _products.where((p) => (p['name'] ?? '').toString().toLowerCase().contains(q) || (p['category'] ?? '').toString().toLowerCase().contains(q)).toList();
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
              SearchField(hint: 'পণ্য অনুসন্ধান...', onChanged: (v) => setState(() => _search = v)),
              const Spacer(),
              ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('পণ্য যোগ করুন')),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: YaruColors.orange))
              : filtered.isEmpty
                  ? const Center(child: Text('কোনো পণ্য নেই', style: TextStyle(color: YaruColors.text3)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Container(
                        decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                            columns: const [
                              DataColumn(label: Text('পণ্য', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('মূল্য', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('ছাড়', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('স্টক', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('ইউনিট', style: TextStyle(color: YaruColors.text2))),
                              DataColumn(label: Text('ক্যাটাগরি', style: TextStyle(color: YaruColors.text2))),
                            ],
                            rows: filtered.map((d) => DataRow(cells: [
                              DataCell(Row(children: [
                                if (d['imageUrl'] != null && d['imageUrl'].toString().isNotEmpty)
                                  ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(d['imageUrl'], width: 36, height: 36, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 36, height: 36)))
                                else
                                  Container(width: 36, height: 36, decoration: BoxDecoration(color: YaruColors.bg3, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.image_outlined, size: 18, color: YaruColors.text3)),
                                const SizedBox(width: 10),
                                Flexible(child: Text(d['name'] ?? '—', style: const TextStyle(color: YaruColors.text, fontSize: 13), overflow: TextOverflow.ellipsis)),
                              ])),
                              DataCell(Text('৳${d['price'] ?? 0}', style: const TextStyle(color: YaruColors.text))),
                              DataCell(Text(d['discountPrice'] != null ? '৳${d['discountPrice']}' : '—', style: const TextStyle(color: YaruColors.green))),
                              DataCell(Text('${d['stock'] ?? 0}', style: TextStyle(color: (d['stock'] ?? 0) < 10 ? YaruColors.red : YaruColors.text, fontWeight: (d['stock'] ?? 0) < 10 ? FontWeight.bold : FontWeight.normal))),
                              DataCell(Text(d['unit'] ?? '—', style: const TextStyle(color: YaruColors.text2))),
                              DataCell(Text(d['category'] ?? '—', style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                            ])).toList(),
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
