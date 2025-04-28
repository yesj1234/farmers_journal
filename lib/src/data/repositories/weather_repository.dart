import 'package:open_meteo/open_meteo.dart';

/// A wrapper function using the open meteo package.
///
/// Defaults to include the weather code which is in form of [WMO](https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM)
class OpenMeteoWeatherRepository {
  const OpenMeteoWeatherRepository(
      {required this.weatherApi, required this.historicalApi});
  final WeatherApi weatherApi;
  final HistoricalApi historicalApi;

  /// Returns a Map<String, dynamic>
  /// 'temperature' : double
  /// 'weatherCode' : int
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
      final response = await weatherApi.request(
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

  /// Returns a Map<String, dynamic>
  ///
  Future<Map<String, dynamic>> requestHistoricalWeather({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    Set<HistoricalHourly> hourly = const {
      HistoricalHourly.weather_code,
      HistoricalHourly.temperature_2m
    },
    Set<HistoricalDaily> daily = const {
      HistoricalDaily.weather_code,
    },
    double? elevation,
  }) async {
    try {
      final response = await historicalApi.request(
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
        startDate: startDate,
        endDate: endDate,
        hourly: hourly,
        daily: daily,
      );

      // TODO: return the array of Map<DateTime, num> which represents the hourly temperature.
      final historicalTemperature =
          response.hourlyData[HistoricalHourly.temperature_2m];

      // Single weather code for the day.
      final historicalWeatherCode =
          response.dailyData[HistoricalDaily.weather_code];

      return {
        'temperature': double.parse(historicalTemperature!
            .values.entries.first.value
            .toStringAsFixed(2)),
        'weatherCode':
            historicalWeatherCode!.values.entries.first.value.toInt(),
      };
    } catch (error) {
      rethrow;
    }
  }
}
