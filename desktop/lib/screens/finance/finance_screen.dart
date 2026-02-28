import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/status_badge.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.transactions();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 14, runSpacing: 14, children: [
            StatCard(label: 'মোট আয়', value: '৳১,২৫,৪৮০', accentColor: YaruColors.green, change: '+18%'),
            StatCard(label: 'আজকের আয়', value: '৳১২,৪৫০', accentColor: YaruColors.orange),
            StatCard(label: 'রিফান্ড', value: '৳৩,২০০', accentColor: YaruColors.red),
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
                  DataColumn(label: Text('তারিখ', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('ধরন', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('পরিমাণ', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('মাধ্যম', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                ],
                rows: data.map((d) => DataRow(cells: [
                  DataCell(Text(d['id'], style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                  DataCell(Text(d['date'], style: const TextStyle(color: YaruColors.text3, fontSize: 12))),
                  DataCell(Text(d['type'], style: const TextStyle(color: YaruColors.text, fontSize: 12))),
                  DataCell(Text(d['amount'], style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                  DataCell(Text(d['method'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
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
