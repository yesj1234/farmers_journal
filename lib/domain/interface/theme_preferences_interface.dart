import 'package:flutter/material.dart';

abstract class ThemePreferencesInterface {
  void fetchUserThemeMode() {}
  void setUserThemeMode(ThemeMode mode) {}
}
