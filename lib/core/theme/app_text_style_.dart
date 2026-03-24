import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

String appFontFamily = GoogleFonts.poppins().fontFamily ?? '';

class AppTextStyles {
  // ---- Light ----
  static TextStyle w300 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w300,
  );

  // ---- Regular ----
  static TextStyle w400 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w400,
  );

  // ---- Medium ----
  static TextStyle w500 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w500,
  );

  // ---- SemiBold ----
  static TextStyle w600 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w600,
  );

  // ---- Bold ----
  static TextStyle w700 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w700,
  );

  static TextStyle w800 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w800,
  );

  static TextStyle w900 = TextStyle(
    fontFamily: appFontFamily,
    fontWeight: FontWeight.w900,
  );
  //--------------------------------------------------

  static final TextStyle h1 = w700.copyWith(
    fontSize: 28,
    color: AppColors.textMain,
  );

  static final TextStyle h2 = w600.copyWith(
    fontSize: 22,
    color: AppColors.textMain,
  );

  static final TextStyle h3 = w600.copyWith(
    fontSize: 18,
    color: AppColors.textMain,
  );

  static final TextStyle bodyLarge = w400.copyWith(
    fontSize: 16,
    color: AppColors.textMain,
  );

  static final TextStyle bodyMedium = w400.copyWith(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static final TextStyle bodySmall = w400.copyWith(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static final TextStyle button = w600.copyWith(
    fontSize: 16,
    color: Colors.white,
  );
}
