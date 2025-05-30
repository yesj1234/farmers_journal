import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repositories/theme_preferences_repository.dart';

part 'local_repository_providers.g.dart';

@riverpod
ThemePreferencesRepository themePreferences(Ref ref) {
  return ThemePreferencesRepository(instance: SharedPreferencesAsync());
}
