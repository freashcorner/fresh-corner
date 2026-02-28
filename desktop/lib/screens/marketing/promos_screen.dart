import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/status_badge.dart';

class PromosScreen extends StatelessWidget {
  const PromosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.promos();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Spacer(),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('প্রোমো তৈরি')),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                columns: const [
                  DataColumn(label: Text('কোড', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('ধরন', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('মান', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('ব্যবহৃত', style: TextStyle(color: YaruColors.text2)), numeric: true),
                  DataColumn(label: Text('সীমা', style: TextStyle(color: YaruColors.text2)), numeric: true),
                  DataColumn(label: Text('মেয়াদ', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                ],
                rows: data.map((d) => DataRow(cells: [
                  DataCell(Text(d['code'], style: const TextStyle(color: YaruColors.orange, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu Mono'))),
                  DataCell(Text(d['type'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                  DataCell(Text(d['value'], style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                  DataCell(Text('${d['used']}', style: const TextStyle(color: YaruColors.text))),
                  DataCell(Text('${d['limit']}', style: const TextStyle(color: YaruColors.text2))),
                  DataCell(Text(d['expires'], style: const TextStyle(color: YaruColors.text3, fontSize: 12))),
                  DataCell(StatusBadge.fromStatus(d['status'])),
                ])).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
