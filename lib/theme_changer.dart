import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDarkMode = false;

  ThemeChanger(this._currentTheme) : _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme {
    if (_isDarkMode) {
      // Dark theme customization
      return ThemeData.dark();
    } else {
      // Light theme customization with gradient background
      return ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      );
    }
  }



  void toggleTheme() {
    // Toggle the theme
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? ThemeData.dark() : _customLightTheme();
    notifyListeners();
  }

  ThemeData _customLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white, // Customize accent color
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff07abb8)), // Set transparent background
      // Add more customizations as needed
    );
  }

  Color getBottomNavBarColor() {
    return _isDarkMode ?  Colors.black : Color(0xff07abb8);
  }
}
