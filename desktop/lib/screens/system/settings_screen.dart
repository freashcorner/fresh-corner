import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, bool> _toggles = {
    'স্টোর চালু': true,
    'মেইনটেন্যান্স মোড': false,
    'অটো-অ্যাসাইন রাইডার': true,
    'পুশ নোটিফিকেশন': true,
    'SMS অ্যালার্ট': false,
    'ইমেইল নোটিফিকেশন': true,
    'অর্ডার সাউন্ড': true,
    'ডার্ক মোড': true,
    'অটো রিফ্রেশ': true,
    'ডেভ মোড': false,
  };

  @override
  Widget build(BuildContext context) {
    final entries = _toggles.entries.toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: List.generate((entries.length / 2).ceil(), (row) {
          return SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                for (int col = 0; col < 2; col++)
                  if (row * 2 + col < entries.length)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: col == 0 ? 14 : 0),
                        child: _buildToggleCard(entries[row * 2 + col]),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildToggleCard(MapEntry<String, bool> entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: YaruColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: YaruColors.border)),
      child: Row(
        children: [
          Expanded(child: Text(entry.key, style: const TextStyle(color: YaruColors.text, fontSize: 14))),
          Switch(
            value: entry.value,
            onChanged: (v) => setState(() => _toggles[entry.key] = v),
            activeColor: YaruColors.orange,
            inactiveTrackColor: YaruColors.bg3,
          ),
        ],
      ),
    );
  }
}
