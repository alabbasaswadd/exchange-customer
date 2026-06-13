import 'package:flutter/material.dart';
import 'core/constants/colors.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme(
    brightness: Brightness.light,

    primary: AppColors.kPrimaryColor,
    onPrimary: Colors.white,

    primaryContainer: AppColors.kSecondColor,
    onPrimaryContainer: Colors.white,

    secondary: AppColors.kSecondColor,
    onSecondary: Colors.white,

    secondaryContainer: AppColors.kThirtColor,
    onSecondaryContainer: Colors.white,

    tertiary: AppColors.kThirtColor,
    onTertiary: Colors.white,

    error: AppColors.kRedColor,
    onError: Colors.white,

    errorContainer: AppColors.kRedColor.withOpacity(0.1),
    onErrorContainer: AppColors.kRedColor,

    surface: const Color(0xFFF8FAFC),
    onSurface: const Color(0xFF111827),

    surfaceContainerHighest: const Color(0xFFF1F5F9),
    outline: const Color(0xFFE2E8F0),

    shadow: Colors.black12,

    inverseSurface: const Color(0xFF111827),
    onInverseSurface: Colors.white,

    inversePrimary: AppColors.kPrimaryColor,

    surfaceTint: AppColors.kPrimaryColor,
    scrim: Colors.black54,
  ),

  scaffoldBackgroundColor: const Color(0xFFF8FAFC),

  cardColor: Colors.white,

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.kPrimaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
  ),

  iconTheme: const IconThemeData(color: AppColors.kPrimaryColor, size: 24),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 52),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 2),
    ),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "Cairo-Bold",
      color: Color(0xFF111827),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontFamily: "Cairo-Bold",
      color: Color(0xFF111827),
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: "Cairo-Bold",
      color: Color(0xFF374151),
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontFamily: "Cairo-Bold",
      color: Color(0xFF6B7280),
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme(
    brightness: Brightness.dark,

    primary: AppColors.kPrimaryColorDarkMode,
    onPrimary: Colors.white,

    primaryContainer: AppColors.kSecondColorDarkMode,
    onPrimaryContainer: Colors.white,

    secondary: AppColors.kSecondColorDarkMode,
    onSecondary: Colors.white,

    secondaryContainer: AppColors.kThirtColorDarkMode,
    onSecondaryContainer: Colors.white,

    tertiary: AppColors.kThirtColorDarkMode,
    onTertiary: Colors.white,

    error: AppColors.kRedColor,
    onError: Colors.white,

    errorContainer: AppColors.kRedColor.withOpacity(0.2),
    onErrorContainer: AppColors.kRedColor,

    surface: const Color(0xFF0F172A),
    onSurface: Colors.white,

    surfaceContainerHighest: const Color(0xFF1E293B),
    outline: const Color(0xFF334155),

    shadow: Colors.black54,

    inverseSurface: Colors.white,
    onInverseSurface: Colors.black,

    inversePrimary: AppColors.kPrimaryColor,

    surfaceTint: AppColors.kPrimaryColorDarkMode,
    scrim: Colors.black54,
  ),

  scaffoldBackgroundColor: const Color(0xFF0F172A),

  cardColor: const Color(0xFF1E293B),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E293B),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.kPrimaryColorDarkMode,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
  ),

  iconTheme: const IconThemeData(color: Colors.white, size: 24),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.kPrimaryColorDarkMode,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 52),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E293B),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF334155)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppColors.kPrimaryColorDarkMode, width: 2),
    ),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: "Cairo-Bold",
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontFamily: "Cairo-Bold",
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: "Cairo-Bold",
      color: Color(0xFFE2E8F0),
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontFamily: "Cairo-Bold",
      color: Color(0xFF94A3B8),
    ),
  ),

  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(Colors.white),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF1E293B),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);
