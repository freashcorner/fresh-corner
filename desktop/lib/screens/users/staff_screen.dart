import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.staff();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
          columns: const [
            DataColumn(label: Text('নাম', style: TextStyle(color: YaruColors.text2))),
            DataColumn(label: Text('ইমেইল', style: TextStyle(color: YaruColors.text2))),
            DataColumn(label: Text('ভূমিকা', style: TextStyle(color: YaruColors.text2))),
            DataColumn(label: Text('সর্বশেষ লগইন', style: TextStyle(color: YaruColors.text2))),
          ],
          rows: data.map((d) => DataRow(cells: [
            DataCell(Row(children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), gradient: const LinearGradient(colors: [Color(0xFF5E2750), Color(0xFF9141AC)])),
                child: Center(child: Text(d['name'][0], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 10),
              Text(d['name'], style: const TextStyle(color: YaruColors.text, fontSize: 13)),
            ])),
            DataCell(Text(d['email'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: YaruColors.orange.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text(d['role'], style: const TextStyle(color: YaruColors.orange, fontSize: 11, fontWeight: FontWeight.w600)),
            )),
            DataCell(Text(d['lastLogin'], style: const TextStyle(color: YaruColors.text3, fontSize: 12))),
          ])).toList(),
        ),
      ),
    );
  }
}
