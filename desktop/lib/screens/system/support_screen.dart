import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/status_badge.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.supportTickets();
    final open = data.where((t) => t['status'] == 'open').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 14, runSpacing: 14, children: [
            StatCard(label: 'মোট টিকেট', value: '${data.length}', accentColor: YaruColors.blue),
            StatCard(label: 'খোলা', value: '$open', accentColor: YaruColors.yellow),
          ]),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
                columns: const [
                  DataColumn(label: Text('আইডি', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('গ্রাহক', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('বিষয়', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('অগ্রাধিকার', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('অ্যাসাইনড', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('তারিখ', style: TextStyle(color: YaruColors.text2))),
                ],
                rows: data.map((d) => DataRow(cells: [
                  DataCell(Text(d['id'], style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                  DataCell(Text(d['customer'], style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                  DataCell(Text(d['subject'], style: const TextStyle(color: YaruColors.text, fontSize: 12))),
                  DataCell(StatusBadge.fromStatus(d['priority'])),
                  DataCell(StatusBadge.fromStatus(d['status'])),
                  DataCell(Text(d['assigned'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                  DataCell(Text(d['created'], style: const TextStyle(color: YaruColors.text3, fontSize: 11))),
                ])).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
