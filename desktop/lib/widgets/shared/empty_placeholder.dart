import 'package:flutter/material.dart';
import '../../config/theme.dart';

class EmptyPlaceholder extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyPlaceholder({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: YaruColors.text3),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: YaruColors.text3, fontSize: 14)),
        ],
      ),
    );
  }
}
