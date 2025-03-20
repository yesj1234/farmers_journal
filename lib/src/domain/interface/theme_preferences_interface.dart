import 'package:flutter/material.dart';

/// {@category Domain}
abstract class ThemePreferencesInterface {
  void fetchUserThemeMode() {}
  void setUserThemeMode(ThemeMode mode) {}
}
