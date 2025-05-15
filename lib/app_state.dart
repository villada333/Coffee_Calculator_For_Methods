// lib/app_state.dart
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _lookResult = false;
  ThemeMode _themeMode = ThemeMode.light;

  bool get lookResult => _lookResult;
  ThemeMode get themeMode => _themeMode;

  set lookResult(bool value) {
    _lookResult = value;
    notifyListeners();
  }

  void setDarkModeSetting(BuildContext context, ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    // Si estás usando un paquete para cambiar el tema dinámicamente,
    // también podrías necesitar interactuar con él aquí.
  }
}