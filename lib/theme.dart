import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late SharedPreferences prefs;
  
  ThemeData light = ThemeData.light().copyWith();
  ThemeData dark = ThemeData.dark().copyWith();

  ThemeProvider(bool isDarkTheme) {
    if (isDarkTheme) {
      _selectedTheme = dark;
    } else {
      _selectedTheme = light;
    }
  }
  
  bool getThemeMode() {
    if (_selectedTheme == dark) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> swapTheme() async {
    prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == dark) {
      _selectedTheme = light;
      await prefs.setBool("darkTheme", false);
    } else {
      _selectedTheme = dark;
      await prefs.setBool("darkTheme", true);
    }

    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}
