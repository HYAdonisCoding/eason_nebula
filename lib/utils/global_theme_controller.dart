import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

Future<void> loadThemeModeFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final themeString = prefs.getString('themeMode');
  switch (themeString) {
    case 'light':
      themeModeNotifier.value = ThemeMode.light;
      break;
    case 'dark':
      themeModeNotifier.value = ThemeMode.dark;
      break;
    case 'system':
    default:
      themeModeNotifier.value = ThemeMode.system;
  }
}

Future<void> saveThemeModeToPrefs(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  final themeString = mode == ThemeMode.light
      ? 'light'
      : mode == ThemeMode.dark
          ? 'dark'
          : 'system';
  await prefs.setString('themeMode', themeString);
}