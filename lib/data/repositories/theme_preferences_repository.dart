import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/interface/theme_preferences_interface.dart';

/// {@category Data}
class ThemePreferencesRepository implements ThemePreferencesInterface {
  ThemePreferencesRepository({required this.instance});
  final SharedPreferencesAsync instance;

  @override
  Future<ThemeMode?> fetchUserThemeMode() async {
    final userMode = await instance.getString('theme');
    if (userMode == 'system') {
      return ThemeMode.system;
    }
    if (userMode == 'light') {
      return ThemeMode.light;
    }
    if (userMode == 'dark') {
      return ThemeMode.dark;
    }
    return ThemeMode
        .system; // default theme, in case when the userMode returns null.
  }

  @override
  void setUserThemeMode(ThemeMode mode) async {
    switch (mode) {
      case ThemeMode.system:
        instance.setString('theme', 'system');
      case ThemeMode.light:
        instance.setString('theme', 'light');
      case ThemeMode.dark:
        instance.setString('theme', 'dark');
    }
  }
}
