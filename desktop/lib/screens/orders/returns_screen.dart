import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/status_badge.dart';

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.returns();
    final pending = data.where((d) => d['status'] == 'pending').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 14, runSpacing: 14, children: [
            StatCard(label: 'মোট রিটার্ন', value: '${data.length}', accentColor: YaruColors.red),
            StatCard(label: 'অপেক্ষমান', value: '$pending', accentColor: YaruColors.yellow),
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
                  DataColumn(label: Text('অর্ডার', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('গ্রাহক', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('কারণ', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('পরিমাণ', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
                  DataColumn(label: Text('তারিখ', style: TextStyle(color: YaruColors.text2))),
                ],
                rows: data.map((d) => DataRow(cells: [
                  DataCell(Text(d['id'], style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                  DataCell(Text(d['orderId'], style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono'))),
                  DataCell(Text(d['customer'], style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                  DataCell(Text(d['reason'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                  DataCell(Text(d['amount'], style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
                  DataCell(StatusBadge.fromStatus(d['status'])),
                  DataCell(Text(d['date'], style: const TextStyle(color: YaruColors.text3, fontSize: 12))),
                ])).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
