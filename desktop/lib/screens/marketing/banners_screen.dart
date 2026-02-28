import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/status_badge.dart';

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.banners();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Spacer(),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_photo_alternate, size: 18), label: const Text('ব্যানার যোগ')),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
              columns: const [
                DataColumn(label: Text('শিরোনাম', style: TextStyle(color: YaruColors.text2))),
                DataColumn(label: Text('অবস্থান', style: TextStyle(color: YaruColors.text2))),
                DataColumn(label: Text('ক্লিক', style: TextStyle(color: YaruColors.text2)), numeric: true),
                DataColumn(label: Text('ইম্প্রেশন', style: TextStyle(color: YaruColors.text2)), numeric: true),
                DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
              ],
              rows: data.map((d) => DataRow(cells: [
                DataCell(Text(d['title'], style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                DataCell(Text(d['position'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                DataCell(Text('${d['clicks']}', style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                DataCell(Text('${d['impressions']}', style: const TextStyle(color: YaruColors.text2))),
                DataCell(StatusBadge.fromStatus(d['status'])),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
