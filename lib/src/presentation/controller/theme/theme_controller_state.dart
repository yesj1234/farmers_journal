import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_controller_state.freezed.dart';

@freezed
sealed class ThemeControllerState with _$ThemeControllerState {
  const factory ThemeControllerState.initial() = Initial;
  const factory ThemeControllerState.data(ThemeMode data) = Data;
  const factory ThemeControllerState.loading() = Loading;
  const factory ThemeControllerState.error(Object? e, [StackTrace? stk]) =
      Error;
}
