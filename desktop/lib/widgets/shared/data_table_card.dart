import 'package:flutter/material.dart';
import '../../config/theme.dart';

class DataTableCard extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String? title;
  final Widget? trailing;

  const DataTableCard({
    super.key,
    required this.columns,
    required this.rows,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: YaruColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: YaruColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Text(title!, style: const TextStyle(color: YaruColors.text, fontSize: 14, fontWeight: FontWeight.w600)),
                  if (trailing != null) ...[const Spacer(), trailing!],
                ],
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
              columns: columns,
              rows: rows,
            ),
          ),
        ],
      ),
    );
  }
}
