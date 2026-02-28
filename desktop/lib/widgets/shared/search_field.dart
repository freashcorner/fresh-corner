import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const SearchField({super.key, this.hint = 'অনুসন্ধান...', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 36,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: YaruColors.text, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: YaruColors.text3, fontSize: 12),
          prefixIcon: const Icon(Icons.search, size: 18, color: YaruColors.text3),
          filled: true,
          fillColor: YaruColors.bg3,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: YaruColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: YaruColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: YaruColors.orange)),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}
