import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2ECC71) : const Color(0xFFD5F5E3),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [const BoxShadow(color: Color(0x442ECC71), blurRadius: 8, offset: Offset(0, 4))]
                    : [],
              ),
              child: Center(
                child: Text(
                  category['icon'] ?? '🛒',
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 62,
              child: Text(
                category['name'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? const Color(0xFF27AE60) : const Color(0xFF2C3E50),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
