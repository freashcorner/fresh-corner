import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';

class ActivityLogsScreen extends StatelessWidget {
  const ActivityLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = MockDataService.activityLogs();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
        child: Column(
          children: logs.map((log) {
            final color = Color(log['color'] as int);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: YaruColors.border))),
              child: Row(
                children: [
                  // Timeline dot
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 14),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(log['user'], style: const TextStyle(color: YaruColors.text, fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(log['action'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('${log['target']}  •  ${log['date']} ${log['time']}', style: const TextStyle(color: YaruColors.text3, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
