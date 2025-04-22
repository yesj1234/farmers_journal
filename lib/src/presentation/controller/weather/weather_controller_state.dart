import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_controller_state.freezed.dart';

@freezed
class WeatherControllerState with _$WeatherControllerState {
  const factory WeatherControllerState.initial() = Initial;
  const factory WeatherControllerState.data(Map weatherInfo) = Data;
  const factory WeatherControllerState.error(Object? e, [StackTrace? stk]) =
      Error;
  const factory WeatherControllerState.loading() = Loading;
}
