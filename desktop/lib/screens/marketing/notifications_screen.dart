import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.sentNotifications();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Spacer(),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.send, size: 18), label: const Text('নতুন নোটিফিকেশন')),
          ]),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
              columns: const [
                DataColumn(label: Text('শিরোনাম', style: TextStyle(color: YaruColors.text2))),
                DataColumn(label: Text('ধরন', style: TextStyle(color: YaruColors.text2))),
                DataColumn(label: Text('পাঠানো', style: TextStyle(color: YaruColors.text2)), numeric: true),
                DataColumn(label: Text('দেখা', style: TextStyle(color: YaruColors.text2)), numeric: true),
                DataColumn(label: Text('তারিখ', style: TextStyle(color: YaruColors.text2))),
              ],
              rows: data.map((d) => DataRow(cells: [
                DataCell(Text(d['title'], style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: YaruColors.blue.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Text(d['type'], style: const TextStyle(color: YaruColors.blue, fontSize: 11, fontWeight: FontWeight.w600)),
                )),
                DataCell(Text(d['sent'], style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                DataCell(Text(d['opened'], style: const TextStyle(color: YaruColors.green))),
                DataCell(Text(d['date'], style: const TextStyle(color: YaruColors.text3, fontSize: 12))),
              ])).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
