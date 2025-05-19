import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_theme.dart';

ThemeData lightTheme = ThemeData(
  // fontFamily: 'Rubik',
  // brightness: Brightness.light,
  primaryColor: Colors.yellow,
  scaffoldBackgroundColor: AppColors.white,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  hintColor: Colors.grey,
  primaryColorLight: AppColors.white,
  canvasColor: AppColors.white,
  shadowColor: const Color(0xfffcf9f4),
  iconTheme: const IconThemeData(color: Colors.black),

  cardColor: const Color(0xFFFFFFFF),
  focusColor: const Color(0xFF1F1F1F),
  dividerColor: const Color(0xFF2A2A2A),

  // errorColor: const Color(0xFFFC6A57),
  primaryColorDark: const Color(0xFFFFFFFF),
  textTheme: const TextTheme(
    labelSmall: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.grey),
    labelLarge: TextStyle(color: Colors.grey),
    displaySmall: TextStyle(color: Colors.grey),
    displayMedium: TextStyle(color: Colors.grey),
    displayLarge: TextStyle(color: Colors.grey),
    headlineSmall: TextStyle(color: Colors.grey),
    headlineMedium: TextStyle(color: Colors.grey),
    headlineLarge: TextStyle(color: Colors.grey),
    titleSmall: TextStyle(color: Colors.grey),
    titleMedium: TextStyle(color: Colors.grey),
    titleLarge: TextStyle(color: Colors.grey),
    bodySmall: TextStyle(color: Colors.grey),
    bodyMedium: TextStyle(color: Colors.grey),
    bodyLarge: TextStyle(color: Colors.grey),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color(0xFF1F1F1F),
  ),
  extensions: [AppTheme()],
);
