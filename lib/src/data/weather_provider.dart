import 'package:farmers_journal/src/data/repositories/weather_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_meteo/open_meteo.dart';

final weatherRepositoryProvider = Provider<OpenMeteoWeatherRepository>((ref) {
  return const OpenMeteoWeatherRepository(
      weatherApi: WeatherApi(), historicalApi: HistoricalApi());
});
