import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _reports = [
    ('বিক্রয় রিপোর্ট', 'দৈনিক/সাপ্তাহিক/মাসিক বিক্রয়', Icons.bar_chart),
    ('অর্ডার রিপোর্ট', 'অর্ডার সংখ্যা ও স্ট্যাটাস', Icons.receipt_long),
    ('পণ্য রিপোর্ট', 'সর্বাধিক বিক্রিত পণ্য', Icons.inventory_2),
    ('রাইডার রিপোর্ট', 'রাইডার পারফরম্যান্স', Icons.delivery_dining),
    ('কাস্টমার রিপোর্ট', 'কাস্টমার অ্যাক্টিভিটি', Icons.people),
    ('ফিনান্স রিপোর্ট', 'আয়-ব্যয় সামারি', Icons.account_balance),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: _reports.map((r) => Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(r.$3, color: YaruColors.orange, size: 28),
              const SizedBox(height: 12),
              Text(r.$1, style: const TextStyle(color: YaruColors.text, fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(r.$2, style: const TextStyle(color: YaruColors.text3, fontSize: 12)),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: YaruColors.orange, side: const BorderSide(color: YaruColors.orange)),
                  child: const Text('জেনারেট করুন'),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}
