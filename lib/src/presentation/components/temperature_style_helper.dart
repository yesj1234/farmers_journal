import 'package:flutter/material.dart';

class TemperatureStyleHelper {
  static TextStyle getStyle(BuildContext context, double temperature) {
    final baseStyle = Theme.of(context).textTheme.labelMedium;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getColor() {
      if (temperature <= 0) {
        return isDarkMode ? Colors.lightBlue[200]! : Colors.blueAccent;
      } else if (temperature <= 15) {
        return isDarkMode ? Colors.cyan[200]! : Colors.cyan;
      } else if (temperature <= 25) {
        return isDarkMode ? Colors.orange[200]! : Colors.orange;
      } else {
        return isDarkMode ? Colors.red[300]! : Colors.redAccent;
      }
    }

    return baseStyle?.copyWith(color: getColor()) ??
        TextStyle(color: getColor());
  }
}
