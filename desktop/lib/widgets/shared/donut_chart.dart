import 'dart:math';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class DonutChartData {
  final String label;
  final double value;
  final Color color;
  const DonutChartData(this.label, this.value, this.color);
}

class DonutChart extends StatelessWidget {
  final List<DonutChartData> data;
  final double size;

  const DonutChart({super.key, required this.data, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _DonutPainter(data)),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data.map((d) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: d.color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Text(d.label, style: const TextStyle(color: YaruColors.text2, fontSize: 12)),
                const SizedBox(width: 6),
                Text('${d.value.toInt()}%', style: const TextStyle(color: YaruColors.text, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutChartData> data;
  _DonutPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(0, (s, d) => s + d.value);
    if (total == 0) return;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height).deflate(4);
    double startAngle = -pi / 2;

    for (final d in data) {
      final sweep = (d.value / total) * 2 * pi;
      final paint = Paint()
        ..color = d.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep - 0.02, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
