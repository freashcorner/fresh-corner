import 'package:flutter/material.dart';
import '../../config/theme.dart';

class TabBarPills extends StatelessWidget {
  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onSelected;

  const TabBarPills({super.key, required this.tabs, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(tabs.length, (i) {
        final active = i == selected;
        return GestureDetector(
          onTap: () => onSelected(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: active ? YaruColors.orange : YaruColors.bg3,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(tabs[i], style: TextStyle(
              color: active ? Colors.white : YaruColors.text2,
              fontSize: 12,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            )),
          ),
        );
      }),
    );
  }
}
