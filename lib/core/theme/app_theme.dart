// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_text_style_.dart';

class AppColors {
  static const Color primary = Color(0xFFF4A64C);
  static const Color secondary = Color(0xFFFFC9A3);
  static const Color background = Color(0xFFFFF8F3);
  static const Color textMain = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.redAccent;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardColor,
        background: AppColors.background,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onSurface: AppColors.textMain,
        onBackground: AppColors.textMain,
      ),

      cardColor: AppColors.cardColor,

      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1,
        titleLarge: AppTextStyles.h2,
        titleMedium: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textMain),
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
