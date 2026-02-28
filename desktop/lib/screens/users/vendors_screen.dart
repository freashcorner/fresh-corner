import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/status_badge.dart';

class VendorsScreen extends StatelessWidget {
  const VendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.vendors();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
            columns: const [
              DataColumn(label: Text('ভেন্ডর', style: TextStyle(color: YaruColors.text2))),
              DataColumn(label: Text('যোগাযোগ', style: TextStyle(color: YaruColors.text2))),
              DataColumn(label: Text('পণ্য', style: TextStyle(color: YaruColors.text2)), numeric: true),
              DataColumn(label: Text('রেটিং', style: TextStyle(color: YaruColors.text2))),
              DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
            ],
            rows: data.map((d) => DataRow(cells: [
              DataCell(Text(d['name'], style: const TextStyle(color: YaruColors.text, fontSize: 13, fontWeight: FontWeight.w500))),
              DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(d['contact'], style: const TextStyle(color: YaruColors.text, fontSize: 12)),
                Text(d['phone'], style: const TextStyle(color: YaruColors.text3, fontSize: 11)),
              ])),
              DataCell(Text('${d['products']}', style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
              DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star, size: 14, color: YaruColors.yellow),
                const SizedBox(width: 4),
                Text(d['rating'], style: const TextStyle(color: YaruColors.text, fontSize: 12)),
              ])),
              DataCell(StatusBadge.fromStatus(d['status'])),
            ])).toList(),
          ),
        ),
      ),
    );
  }
}
