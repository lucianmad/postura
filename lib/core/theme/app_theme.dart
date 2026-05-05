import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF12121A);
  static const Color surface = Color(0xFF1E1E2E);
  static const Color accent = Color(0xFF6C63FF);
  static const Color good = Color(0xFF4CAF50);
  static const Color bad = Color(0xFFEF5350);
  static const Color info = Color(0xFFFF9800);
  static const Color neutral = Color(0xFF9E9E9E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    colorScheme: ColorScheme.dark(
      primary: AppColors.accent,
      surface: AppColors.surface,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textSecondary,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.08),
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.neutral,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
