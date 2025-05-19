import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension ThemeDataExtension on ThemeData {
  AppTheme get colorTheme => extension<AppTheme>() ?? AppTheme();
}

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension MediaQueryExtension on BuildContext {
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;
  bool get isKeyboardVisible => !(mediaQuery.viewInsets.bottom == 0.0);
}
