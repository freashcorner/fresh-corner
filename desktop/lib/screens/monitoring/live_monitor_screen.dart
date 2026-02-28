import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/shared/stat_card.dart';
import '../../widgets/shared/status_badge.dart';
import '../../widgets/shared/section_header.dart';

class LiveMonitorScreen extends StatelessWidget {
  const LiveMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.liveData();
    final orders = data['recentOrders'] as List;
    final heatmap = data['heatmap'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 14, runSpacing: 14,
            children: [
              StatCard(label: 'সক্রিয় অর্ডার', value: '${data['activeOrders']}', accentColor: YaruColors.orange),
              StatCard(label: 'অনলাইন রাইডার', value: '${data['onlineRiders']}', accentColor: YaruColors.green),
              StatCard(label: 'গড় ডেলিভারি', value: data['avgDeliveryTime'], accentColor: YaruColors.blue),
              StatCard(label: 'ডিসপ্যাচ অপেক্ষায়', value: '${data['pendingDispatch']}', accentColor: YaruColors.yellow),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live order feed
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'লাইভ অর্ডার ফিড'),
                    Container(
                      decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                      child: Column(
                        children: orders.map<Widget>((o) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: YaruColors.border))),
                          child: Row(
                            children: [
                              Text(o['id'], style: const TextStyle(color: YaruColors.text2, fontSize: 12, fontFamily: 'Ubuntu Mono')),
                              const SizedBox(width: 12),
                              Expanded(child: Text(o['customer'], style: const TextStyle(color: YaruColors.text, fontSize: 13))),
                              Text(o['area'], style: const TextStyle(color: YaruColors.text2, fontSize: 12)),
                              const SizedBox(width: 12),
                              StatusBadge.fromStatus(o['status']),
                              const SizedBox(width: 12),
                              Text(o['time'], style: const TextStyle(color: YaruColors.text3, fontSize: 11)),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Map placeholder + heatmap
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'ডেলিভারি ম্যাপ'),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(color: YaruColors.bg3, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                      child: const Center(child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map_outlined, size: 40, color: YaruColors.text3),
                          SizedBox(height: 8),
                          Text('ম্যাপ শীঘ্রই আসছে', style: TextStyle(color: YaruColors.text3, fontSize: 12)),
                        ],
                      )),
                    ),
                    const SizedBox(height: 20),
                    const SectionHeader(title: 'অর্ডার হিটম্যাপ'),
                    Container(
                      decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
                      child: Column(
                        children: heatmap.map<Widget>((h) {
                          const maxOrders = 30;
                          final pct = (h['orders'] as int) / maxOrders;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            child: Row(
                              children: [
                                SizedBox(width: 80, child: Text(h['area'], style: const TextStyle(color: YaruColors.text2, fontSize: 12))),
                                Expanded(
                                  child: Container(
                                    height: 14,
                                    decoration: BoxDecoration(color: YaruColors.bg3, borderRadius: BorderRadius.circular(3)),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: pct.clamp(0.0, 1.0),
                                      child: Container(decoration: BoxDecoration(color: YaruColors.orange, borderRadius: BorderRadius.circular(3))),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('${h['orders']}', style: const TextStyle(color: YaruColors.text, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
