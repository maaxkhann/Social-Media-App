import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../constants/app_colors.dart';

ThemeData darkTheme = ThemeData(
  // fontFamily: 'Rubik',
  // brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF161C24),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  hintColor: Colors.white,
  canvasColor: const Color(0xFFF9FAFA),
  primaryColorLight: AppColors.white,
  shadowColor: const Color(0xfff7f7f7),
  iconTheme: const IconThemeData(color: Colors.white),
  // backgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  primaryColor: const Color(0xFF82CAB6),
  focusColor: const Color(0xFF8D8D8D),
  dividerColor: const Color(0xFF2A2A2A),
  // errorColor: const Color(0xFFCF6679),
  primaryColorDark: const Color(0xFF000000),
  textTheme: const TextTheme(
    labelSmall: TextStyle(color: Colors.white),
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
    secondary: const Color(0xFFFFFFFF),
  ),
  extensions: [AppTheme.dark()],
);
