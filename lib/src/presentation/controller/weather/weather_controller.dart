import 'package:farmers_journal/src/data/weather_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/firestore_providers.dart';
import 'weather_controller_state.dart';

part 'weather_controller.g.dart';

@riverpod
class WeatherController extends _$WeatherController {
  double? _latitude;
  double? _longitude;
  @override
  WeatherControllerState build({Map? initialWeatherInfo}) {
    if (initialWeatherInfo == null) {
      currentWeather();
      return const WeatherControllerState.initial();
    } else {
      return WeatherControllerState.data(initialWeatherInfo);
    }
  }

  void currentWeather() async {
    state = const WeatherControllerState.loading();
    try {
      final api = ref.read(weatherRepositoryProvider);
      final userInfo = await ref.read(userRepositoryProvider).getUser();

      final double latitude = userInfo!.plants.first.lat;
      final double longitude = userInfo.plants.first.lng;
      _latitude = latitude;
      _longitude = longitude;
      final response =
          await api.requestWeather(latitude: latitude, longitude: longitude);
      state = WeatherControllerState.data(response);
    } catch (error) {
      state = WeatherControllerState.error(error);
    }
  }

  void setWeather({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_latitude == null || _longitude == null) {
      try {
        final userInfo = await ref.read(userRepositoryProvider).getUser();

        final double latitude = userInfo!.plants.first.lat;
        final double longitude = userInfo.plants.first.lng;
        _latitude = latitude;
        _longitude = longitude;
      } catch (error) {
        state = WeatherControllerState.error(error);
        return;
      }
    }
    try {
      final api = ref.read(weatherRepositoryProvider);
      final response = await api.requestHistoricalWeather(
          latitude: _latitude ?? 0,
          longitude: _longitude ?? 0,
          startDate: startDate,
          endDate: endDate);
      state = WeatherControllerState.data(response);
    } catch (error) {
      state = WeatherControllerState.error(error);
    }
  }
}
