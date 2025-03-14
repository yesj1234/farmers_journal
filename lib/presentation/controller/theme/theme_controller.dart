import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'theme_controller_state.dart';

part 'theme_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  ThemeMode _mode = ThemeMode.system;
  @override
  ThemeControllerState build() {
    // fetchUserThemeMode();
    return ThemeControllerState.data(_mode);
  }

  void fetchUserThemeMode() async {
    state = const ThemeControllerState.loading();
    // try loading the user's selected mode.
    try {
      state = ThemeControllerState.data(_mode);
    } catch (e) {
      state = const ThemeControllerState.data(ThemeMode.system);
      throw Exception(e);
    }
  }

  // set the user's selected theme
  void setUserThemeMode(ThemeMode mode) {
    _mode = mode;
    state = ThemeControllerState.data(_mode);
  }
}
