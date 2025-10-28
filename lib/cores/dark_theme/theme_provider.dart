import 'package:cscc_app/cores/dark_theme/theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final appThemeProvider = ChangeNotifierProvider((ref) => AppThemeState());

class AppThemeState with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  ThemeMode get _themeMode => themeMode;

  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;

 set _themeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }
  // set themeData(ThemeData theme) {
  //   _themeData = theme;
  //   notifyListeners();
  // }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }
  void useSystemTheme() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }
}
