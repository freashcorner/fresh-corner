import 'package:flutter/material.dart';

class YaruColors {
  static const orange = Color(0xFFE95420);
  static const orangeLight = Color(0xFFF47956);
  static const orangeDark = Color(0xFFC34113);
  static const green = Color(0xFF26A269);
  static const red = Color(0xFFE01B24);
  static const yellow = Color(0xFFF5C211);
  static const blue = Color(0xFF1C71D8);
  static const purple = Color(0xFF9141AC);
  static const cyan = Color(0xFF00B4D8);

  static const bg = Color(0xFF1C1C1C);
  static const bg2 = Color(0xFF2D2D2D);
  static const bg3 = Color(0xFF3C3C3C);
  static const bg4 = Color(0xFF252525);
  static const card = Color(0xFF2D2D2D);
  static const card2 = Color(0xFF363636);
  static const sidebar = Color(0xFF252525);

  static const text = Color(0xFFF2F2F2);
  static const text2 = Color(0x99F2F2F2);
  static const text3 = Color(0x59F2F2F2);
  static const border = Color(0x1AFFFFFF);
  static const border2 = Color(0x0FFFFFFF);
}

ThemeData buildYaruTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: YaruColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: YaruColors.bg2,
      primary: YaruColors.orange,
      secondary: YaruColors.green,
      error: YaruColors.red,
    ),
    fontFamily: 'Ubuntu',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: YaruColors.text, fontFamily: 'Ubuntu'),
      bodyMedium: TextStyle(color: YaruColors.text, fontFamily: 'Ubuntu'),
      bodySmall: TextStyle(color: YaruColors.text2, fontFamily: 'Ubuntu'),
      titleLarge: TextStyle(color: YaruColors.text, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'),
      titleMedium: TextStyle(color: YaruColors.text, fontWeight: FontWeight.w600, fontFamily: 'Ubuntu'),
      labelSmall: TextStyle(color: YaruColors.text3, fontFamily: 'Ubuntu'),
    ),
    cardTheme: CardThemeData(
      color: YaruColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: YaruColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: YaruColors.bg3,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: YaruColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: YaruColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: YaruColors.orange),
      ),
      hintStyle: const TextStyle(color: YaruColors.text3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: YaruColors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.04)),
      dataRowColor: WidgetStateProperty.all(Colors.transparent),
      headingTextStyle: const TextStyle(color: YaruColors.text2, fontSize: 12, fontWeight: FontWeight.w600),
      dataTextStyle: const TextStyle(color: YaruColors.text, fontSize: 13),
    ),
    useMaterial3: true,
  );
}
