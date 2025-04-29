import 'package:flutter/material.dart';

import 'temperature_style_helper.dart';
import 'weather_icon_helper.dart';

class WeatherIconBuilder extends StatelessWidget {
  const WeatherIconBuilder({
    super.key,
    required this.temperature,
    required this.weatherCode,
    this.iconSize = 16,
  });

  final double? temperature;
  final int? weatherCode;
  final double? iconSize;
  @override
  Widget build(BuildContext context) {
    final icon = WeatherIconHelper.getIcon(weatherCode!);
    final iconColor = WeatherIconHelper.getColor(icon);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 4,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        Text(
          '$temperature℃',
          style: TemperatureStyleHelper.getStyle(context, temperature!),
        ),
      ],
    );
  }
}
