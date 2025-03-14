import 'package:farmers_journal/data/repositories/theme_preferences_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themePreferencesProvider = Provider<ThemePreferencesRepository>((ref) {
  return ThemePreferencesRepository(instance: SharedPreferencesAsync());
});
