import 'package:farmers_journal/src/data/repositories/weather_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_provider.g.dart';

@riverpod
OpenMeteoWeatherRepository weatherRepository(Ref ref) {
  return const OpenMeteoWeatherRepository(
      weatherApi: WeatherApi(), historicalApi: HistoricalApi());
}
