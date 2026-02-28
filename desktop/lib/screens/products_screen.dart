import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
      setState(() {
        _products = List<Map<String, dynamic>>.from(list);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
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
                const Text('পণ্য', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white38),
                  onPressed: _load,
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE95420)))
                : _products.isEmpty
                    ? const Center(child: Text('কোনো পণ্য নেই', style: TextStyle(color: Colors.white38)))
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
                              DataColumn(label: Text('পণ্যের নাম', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('মূল্য', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('ছাড়ের মূল্য', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('স্টক', style: TextStyle(color: Colors.white54))),
                              DataColumn(label: Text('ইউনিট', style: TextStyle(color: Colors.white54))),
                            ],
                            rows: _products.map((d) {
                              return DataRow(cells: [
                                DataCell(Row(
                                  children: [
                                    if (d['imageUrl'] != null && d['imageUrl'].toString().isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(d['imageUrl'], width: 36, height: 36, fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const SizedBox(width: 36, height: 36)),
                                      )
                                    else
                                      const SizedBox(width: 36, height: 36),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(d['name'] ?? '—', style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
                                  ],
                                )),
                                DataCell(Text('৳${d['price'] ?? 0}', style: const TextStyle(color: Colors.white))),
                                DataCell(Text(d['discountPrice'] != null ? '৳${d['discountPrice']}' : '—', style: const TextStyle(color: Color(0xFF26A269)))),
                                DataCell(Text('${d['stock'] ?? 0}', style: TextStyle(color: (d['stock'] ?? 0) < 10 ? Colors.red : Colors.white))),
                                DataCell(Text(d['unit'] ?? '—', style: const TextStyle(color: Colors.white54))),
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
