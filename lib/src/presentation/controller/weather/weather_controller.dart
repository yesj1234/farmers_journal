import 'package:farmers_journal/src/data/weather_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/firestore_providers.dart';
import 'weather_controller_state.dart';

part 'weather_controller.g.dart';

@riverpod
class WeatherController extends _$WeatherController {
  @override
  WeatherControllerState build() {
    currentWeather();
    return const WeatherControllerState.initial();
  }

  void currentWeather() async {
    state = const WeatherControllerState.loading();
    try {
      final api = ref.read(weatherRepositoryProvider);
      final userInfo = await ref.read(userRepositoryProvider).getUser();

      final double latitude = userInfo!.plants.first.lat;
      final double longitude = userInfo.plants.first.lng;

      final response =
          await api.requestWeather(latitude: latitude, longitude: longitude);
      state = WeatherControllerState.data(response);
    } catch (error) {
      state = WeatherControllerState.error(error);
    }
  }
}
