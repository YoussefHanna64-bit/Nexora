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
    surface: AppColors.darkSurface,
    onSurface: AppColors.whiteColor,
    onPrimary: AppColors.whiteColor,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  primaryColor: AppColors.primary,
  dividerColor: AppColors.darkDivider,
  cardColor: AppColors.darkSurface,
);


final ThemeData appTheme = lightTheme;