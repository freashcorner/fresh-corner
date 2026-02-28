import 'package:flutter/material.dart';
import '../../config/theme.dart';

class BarChartData {
  final String label;
  final double value;
  const BarChartData(this.label, this.value);
}

class SimpleBarChart extends StatelessWidget {
  final List<BarChartData> data;
  final Color barColor;
  final double height;

  const SimpleBarChart({super.key, required this.data, this.barColor = YaruColors.orange, this.height = 180});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.fold<double>(0, (m, d) => d.value > m ? d.value : m);
    if (maxVal == 0) return SizedBox(height: height);

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((d) {
          final barH = (d.value / maxVal) * (height - 24);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: barH,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(d.label, style: const TextStyle(color: YaruColors.text3, fontSize: 9), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
