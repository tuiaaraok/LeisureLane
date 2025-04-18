import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  // Инициализация Hive box
  Box? settingsBox;

  // Используем late для отложенной инициализации переменной
  late bool _isDarkMode;

  ThemeProvider(this.settingsBox) {
    // Загружаем значение из Hive
    _isDarkMode = settingsBox?.get('isDarkMode', defaultValue: false) ?? false;
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    settingsBox?.put('isDarkMode', _isDarkMode); // Сохраняем значение в Hive
    notifyListeners();
  }

  Color get backgroundColor =>
      _isDarkMode ? Colors.black : const Color(0xFFF5FAFF);

  Color get iconColor => _isDarkMode ? Colors.white : Colors.black;

  Color get containerColor => _isDarkMode ? Colors.black : Colors.white;
  Color get borderColor => _isDarkMode ? Colors.white : Colors.black;
  Color get pinkColor =>
      _isDarkMode ? const Color(0xFFFF6E88) : const Color(0xFFFF5474);
  Color get textContainerColor => _isDarkMode ? Colors.black : Colors.white;
  Color get titleColor => _isDarkMode ? Colors.white : Colors.black;
  Color get greenColor =>
      _isDarkMode ? const Color(0xFF009E83) : const Color(0xFF00846F);

  Color get switchColor => _isDarkMode ? Colors.white : Colors.pink;
}
