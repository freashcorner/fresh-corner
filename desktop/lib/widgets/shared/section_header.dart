import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: YaruColors.text, fontSize: 16, fontWeight: FontWeight.bold)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}
