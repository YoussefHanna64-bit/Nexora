import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.whiteColor,
    onSurface: AppColors.blackColor,
    onPrimary: AppColors.whiteColor,
  ),
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  dividerColor: AppColors.lightGrey,
  cardColor: AppColors.whiteColor,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: const Color(0xFF1E1E2E),
    onSurface: AppColors.whiteColor,
    onPrimary: AppColors.whiteColor,
  ),
  scaffoldBackgroundColor: const Color(0xFF121218),
  primaryColor: AppColors.primary,
  dividerColor: const Color(0xFF3A3A4A),
  cardColor: const Color(0xFF1E1E2E),
);


final ThemeData appTheme = lightTheme;