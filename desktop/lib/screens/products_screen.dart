import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('পণ্য', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').where('isActive', isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFE95420)));
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text('কোনো পণ্য নেই', style: TextStyle(color: Colors.white38)));

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.white.withOpacity(0.04)),
                      columns: const [
                        DataColumn(label: Text('পণ্যের নাম', style: TextStyle(color: Colors.white54))),
                        DataColumn(label: Text('মূল্য', style: TextStyle(color: Colors.white54))),
                        DataColumn(label: Text('ছাড়ের মূল্য', style: TextStyle(color: Colors.white54))),
                        DataColumn(label: Text('স্টক', style: TextStyle(color: Colors.white54))),
                        DataColumn(label: Text('ইউনিট', style: TextStyle(color: Colors.white54))),
                      ],
                      rows: docs.map((doc) {
                        final d = doc.data() as Map<String, dynamic>;
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
