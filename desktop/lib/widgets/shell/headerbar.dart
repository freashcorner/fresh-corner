import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';

class Headerbar extends StatelessWidget {
  final PageId activePage;

  const Headerbar({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    final section = pageSectionLabel(activePage);
    final page = pageBengaliLabel(activePage);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: YaruColors.bg2,
        border: Border(bottom: BorderSide(color: YaruColors.border)),
      ),
      child: Row(
        children: [
          // Breadcrumb
          Text(section, style: const TextStyle(color: YaruColors.text3, fontSize: 13)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.chevron_right, size: 16, color: YaruColors.text3),
          ),
          Text(page, style: const TextStyle(color: YaruColors.text, fontSize: 13, fontWeight: FontWeight.w600)),
          const Spacer(),
          // Search
          Container(
            width: 220,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: YaruColors.bg3,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: YaruColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 16, color: YaruColors.text3),
                SizedBox(width: 8),
                Text('অনুসন্ধান...', style: TextStyle(color: YaruColors.text3, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Notification bell
          Stack(
            children: [
              const Icon(Icons.notifications_outlined, size: 20, color: YaruColors.text2),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: YaruColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // User avatar
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF5E2750), Color(0xFF9141AC)],
              ),
            ),
            child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
    );
  }
}
