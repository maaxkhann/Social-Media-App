import 'package:flutter/material.dart';
import 'package:social_media/constants/app_colors.dart';

class AppTheme extends ThemeExtension<AppTheme> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color white;
  final Color black;

  AppTheme({
    this.white = AppColors.white,
    this.black = AppColors.black,
    this.primaryColor = AppColors.primaryColor,
    this.secondaryColor = AppColors.black,
  });

  factory AppTheme.dark() {
    return AppTheme(primaryColor: Colors.black, secondaryColor: Colors.brown);
  }

  @override
  ThemeExtension<AppTheme> copyWith({
    Color? appPrimaryColor,
    Color? appSecondaryColor,
  }) {
    return AppTheme(
      primaryColor: appPrimaryColor ?? primaryColor,
      secondaryColor: appSecondaryColor ?? secondaryColor,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(
    covariant ThemeExtension<AppTheme>? other,
    double t,
  ) {
    if (other == null || other is! AppTheme) {
      return this;
    }
    return AppTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
    );
  }
}
