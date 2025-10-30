import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cscc_app/cores/dark_theme/theme_page.dart';

final appThemeProvider = ChangeNotifierProvider((ref) => AppThemeState());

class AppThemeState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      themeMode = ThemeMode.dark;
    } else {
      _themeData = lightTheme;
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  
  void useSystemTheme() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }

  
  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    _themeData = (mode == ThemeMode.dark)
        ? darkTheme
        : lightTheme;
    notifyListeners();
  }
}
