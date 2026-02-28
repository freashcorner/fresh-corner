import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/status_badge.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.categories();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
          columns: const [
            DataColumn(label: Text('আইকন', style: TextStyle(color: YaruColors.text2))),
            DataColumn(label: Text('ক্যাটাগরি', style: TextStyle(color: YaruColors.text2))),
            DataColumn(label: Text('পণ্য সংখ্যা', style: TextStyle(color: YaruColors.text2)), numeric: true),
            DataColumn(label: Text('স্ট্যাটাস', style: TextStyle(color: YaruColors.text2))),
          ],
          rows: data.map((d) => DataRow(cells: [
            DataCell(Text(d['icon'] ?? '', style: const TextStyle(fontSize: 20))),
            DataCell(Text(d['name'], style: const TextStyle(color: YaruColors.text, fontSize: 13, fontWeight: FontWeight.w500))),
            DataCell(Text('${d['products']}', style: const TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold))),
            DataCell(StatusBadge.fromStatus(d['status'])),
          ])).toList(),
        ),
      ),
    );
  }
}
