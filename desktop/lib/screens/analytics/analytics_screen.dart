import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/bar_chart.dart';
import '../../widgets/shared/donut_chart.dart';
import '../../widgets/shared/section_header.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.analyticsSummary();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 14, runSpacing: 14, children: [
            StatCard(label: 'মোট আয়', value: data['totalRevenue'], accentColor: YaruColors.green, change: '+18%'),
            StatCard(label: 'মোট অর্ডার', value: data['totalOrders'], accentColor: YaruColors.blue, change: '+12%'),
            StatCard(label: 'গড় অর্ডার মূল্য', value: data['avgOrderValue'], accentColor: YaruColors.orange),
            StatCard(label: 'পুনরাবৃত্তি হার', value: data['repeatRate'], accentColor: YaruColors.purple),
          ]),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'দৈনিক আয়'),
                      SimpleBarChart(
                        data: (data['dailyRevenue'] as List).map((e) => BarChartData((e as BarChartEntry).label, e.value)).toList(),
                        barColor: YaruColors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'ক্যাটাগরি ভাগ'),
                      DonutChart(
                        data: (data['categoryBreakdown'] as List).map((e) {
                          final d = e as DonutEntry;
                          return DonutChartData(d.label, d.value, Color(d.colorValue));
                        }).toList(),
                        size: 130,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
