import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';

class Sidebar extends StatelessWidget {
  final PageId activePage;
  final ValueChanged<PageId> onPageSelected;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.activePage,
    required this.onPageSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: YaruColors.sidebar,
      child: Column(
        children: [
          // Logo header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A4731), Color(0xFF2ECC71)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ফ্রেশ কর্নার', style: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Admin Panel', style: TextStyle(color: YaruColors.text3, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // User info
          Container(
            margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: YaruColors.bg2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5E2750), Color(0xFF9141AC)],
                    ),
                  ),
                  child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Admin', style: TextStyle(color: YaruColors.text, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(AuthService.email ?? 'admin@freshcorner.com', style: const TextStyle(color: YaruColors.text3, fontSize: 10), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: YaruColors.border, height: 1),
          // Nav sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: navSections.map((section) => _buildSection(section)).toList(),
            ),
          ),
          const Divider(color: YaruColors.border, height: 1),
          // Logout
          InkWell(
            onTap: onLogout,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Icon(Icons.logout, color: YaruColors.text3, size: 18),
                  SizedBox(width: 10),
                  Text('লগ আউট', style: TextStyle(color: YaruColors.text3, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(NavSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(section.label, style: const TextStyle(color: YaruColors.text3, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ),
        ...section.items.map((item) => _buildNavItem(item)),
      ],
    );
  }

  Widget _buildNavItem(NavItem item) {
    final active = item.id == activePage;
    return InkWell(
      onTap: () => onPageSelected(item.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: active ? YaruColors.orange.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: active ? YaruColors.orange : YaruColors.text2),
            const SizedBox(width: 10),
            Expanded(
              child: Text(item.label, style: TextStyle(
                color: active ? YaruColors.orange : YaruColors.text,
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              )),
            ),
            if (item.badge > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: active ? YaruColors.orange : YaruColors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${item.badge}', style: TextStyle(
                  color: active ? Colors.white : YaruColors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )),
              ),
          ],
        ),
      ),
    );
  }
}
