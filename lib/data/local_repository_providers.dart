import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'repositories/theme_preferences_repository.dart';

final themePreferencesProvider = Provider<ThemePreferencesRepository>((ref) {
  return ThemePreferencesRepository(instance: SharedPreferencesAsync());
});
