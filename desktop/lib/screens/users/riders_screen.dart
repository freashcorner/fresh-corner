import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/status_badge.dart';

class RidersScreen extends StatelessWidget {
  const RidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.riders();
    final active = data.where((r) => r['status'] == 'active').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 14, runSpacing: 14, children: [
            StatCard(label: 'মোট রাইডার', value: '${data.length}', accentColor: YaruColors.blue),
            StatCard(label: 'সক্রিয়', value: '$active', accentColor: YaruColors.green),
          ]),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                columns: const [
                  DataColumn(label: Text('রাইডার', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('ডেলিভারি', style: TextStyle(color: YaruColors.text2)), numeric: true),
                  DataColumn(label: Text('রেটিং', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('আয়', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('এলাকা', style: TextStyle(color: YaruColors.text2))),
                ],
                rows: data.map((d) => DataRow(cells: [
                  DataCell(Row(children: [
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(colors: [Color(0xFF5E2750), Color(0xFF9141AC)])),
                      child: Center(child: Text(d['name'][0], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(d['name'], style: const TextStyle(color: YaruColors.text, fontSize: 13)),
                      Text(d['phone'], style: const TextStyle(color: YaruColors.text3, fontSize: 11)),
                    ]),
                  ])),
                  DataCell(StatusBadge.fromStatus(d['status'])),
                  DataCell(Text('${d['deliveries']}', style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, size: 14, color: YaruColors.yellow),
                    const SizedBox(width: 4),
                    Text(d['rating'], style: const TextStyle(color: YaruColors.text, fontSize: 12)),
                  ])),
                  DataCell(Text(d['earnings'], style: const TextStyle(color: YaruColors.green, fontWeight: FontWeight.bold))),
                  DataCell(Text(d['area'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                ])).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
