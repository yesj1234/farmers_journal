import 'dart:io';

import 'package:open_meteo/open_meteo.dart';

class OpenMeteoWeatherRepository {
  const OpenMeteoWeatherRepository({required this.api});
  final WeatherApi api;
  // A wrapper function using the open meteo package.
  // defaults to include the weather code which is in form of [WMO](https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM)
  Future<Map<String, dynamic>> requestWeather({
    required double latitude,
    required double longitude,
    Set<WeatherHourly> hourly = const {},
    Set<WeatherDaily> daily = const {},
    Set<WeatherCurrent> current = const {
      WeatherCurrent.weather_code,
      WeatherCurrent.temperature_2m
    },
    Set<WeatherMinutely15> minutely15 = const {},
    double? elevation,
    int? pastDays,
    int? pastHours,
    int? pastMinutely15,
    int? forecastDays,
    int? forecastHours,
    int? forecastMinutely15,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startHour,
    DateTime? endHour,
  }) async {
    try {
      final response = await api.request(
        latitude: latitude,
        longitude: longitude,
        hourly: hourly,
        daily: daily,
        current: current,
        minutely15: minutely15,
        elevation: elevation,
        pastDays: pastDays,
        pastMinutely15: pastMinutely15,
        forecastDays: forecastDays,
        forecastHours: forecastHours,
        forecastMinutely15: forecastMinutely15,
        startDate: startDate,
        endDate: endDate,
        startHour: startHour,
        endHour: endHour,
      );
      final currentTemperature =
          response.currentData[WeatherCurrent.temperature_2m];
      final currentWeatherCode =
          response.currentData[WeatherCurrent.weather_code];
      return {
        'temperature':
            double.parse(currentTemperature!.value.toStringAsFixed(2)),
        'weatherCode': currentWeatherCode!.value.toInt(),
      };
    } catch (error) {
      rethrow;
    }
  }
}
