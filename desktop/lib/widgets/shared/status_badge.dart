import 'package:flutter/material.dart';
import '../../config/theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  factory StatusBadge.fromStatus(String status) {
    final map = {
      'pending': (YaruColors.yellow, 'অপেক্ষমান'),
      'confirmed': (YaruColors.blue, 'নিশ্চিত'),
      'processing': (YaruColors.purple, 'প্রস্তুত'),
      'shipped': (YaruColors.cyan, 'পাঠানো'),
      'delivered': (YaruColors.green, 'পৌঁছেছে'),
      'cancelled': (YaruColors.red, 'বাতিল'),
      'assigned': (YaruColors.blue, 'নিযুক্ত'),
      'picked': (YaruColors.purple, 'নেওয়া হয়েছে'),
      'on_way': (YaruColors.orange, 'পথে আছে'),
      'active': (YaruColors.green, 'সক্রিয়'),
      'inactive': (YaruColors.text3, 'নিষ্ক্রিয়'),
      'resolved': (YaruColors.green, 'সমাধান'),
      'open': (YaruColors.yellow, 'খোলা'),
      'closed': (YaruColors.text3, 'বন্ধ'),
      'high': (YaruColors.red, 'উচ্চ'),
      'medium': (YaruColors.yellow, 'মাঝারি'),
      'low': (YaruColors.green, 'নিম্ন'),
    };
    final entry = map[status];
    return StatusBadge(label: entry?.$2 ?? status, color: entry?.$1 ?? YaruColors.text3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
