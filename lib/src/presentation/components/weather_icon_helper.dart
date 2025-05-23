import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

/// Helper class that maps (WMO)[https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM] code into matching weather icon.
class WeatherIconHelper {
  /// Returns the appropriate color for a given weather icon.
  static Color getColor(IconData icon) {
    switch (icon) {
      case Icons.sunny:
        return Colors.amber;
      case FontAwesomeIcons.smog:
        return Colors.brown;
      case FontAwesomeIcons.wind:
        return Colors.lightBlue;
      case FontAwesomeIcons.bolt:
        return Colors.deepPurpleAccent;
      case FontAwesomeIcons.cloudRain:
        return Colors.blueGrey;
      case FontAwesomeIcons.tornado:
        return Colors.grey;
      case FontAwesomeIcons.cloud:
        return Colors.blueGrey;
      case FontAwesomeIcons.snowflake:
        return Colors.lightBlueAccent;
      case FontAwesomeIcons.cloudShowersHeavy:
        return Colors.indigo;
      case FontAwesomeIcons.question:
        return Colors.grey;
      default:
        return Colors.grey; // Fallback for any unknown icon
    }
  }

  static IconData getIcon(int wmoCode) {
    if (wmoCode < 0 || wmoCode > 99) {
      return FontAwesomeIcons.question;
    }

    switch (wmoCode) {
      case 0:
      case 1:
      case 2:
      case 3:
        return Icons.sunny;
      case 4:
      case 5:
        return FontAwesomeIcons.smog;
      case 6:
      case 7:
      case 8:
      case 9:
        return FontAwesomeIcons.wind;
      case 10:
        return FontAwesomeIcons.smog;
      case 11:
      case 12:
        return FontAwesomeIcons.smog;
      case 13:
        return FontAwesomeIcons.bolt;
      case 14:
      case 15:
      case 16:
        return FontAwesomeIcons.cloudRain;
      case 17:
        return FontAwesomeIcons.bolt;
      case 18:
        return FontAwesomeIcons.wind;
      case 19:
        return FontAwesomeIcons.tornado;
      case 20:
      case 21:
      case 22:
        return FontAwesomeIcons.cloud;
      case 23:
      case 24:
        return FontAwesomeIcons.snowflake;
      case 25:
      case 26:
        return FontAwesomeIcons.cloudRain;
      case 27:
      case 28:
      case 29:
      case 30:
      case 31:
      case 32:
      case 33:
      case 34:
      case 35:
      case 36:
      case 37:
      case 38:
      case 39:
      case 40:
      case 41:
      case 42:
      case 43:
      case 44:
      case 45:
      case 46:
      case 47:
      case 48:
      case 49:
        return FontAwesomeIcons.snowflake;
      case 50:
      case 51:
      case 52:
      case 53:
      case 54:
      case 55:
      case 56:
      case 57:
      case 58:
      case 59:
      case 60:
      case 61:
      case 62:
      case 63:
      case 64:
      case 65:
      case 66:
      case 67:
      case 68:
      case 69:
        return FontAwesomeIcons.cloudRain;
      case 70:
      case 71:
      case 72:
      case 73:
      case 74:
      case 75:
      case 76:
      case 77:
      case 78:
      case 79:
        return FontAwesomeIcons.snowflake;
      case 80:
      case 81:
      case 82:
      case 83:
      case 84:
      case 85:
      case 86:
      case 87:
      case 88:
      case 89:
      case 90:
        return FontAwesomeIcons.cloudShowersHeavy;
      case 91:
      case 92:
      case 93:
      case 94:
      case 95:
      case 96:
      case 97:
      case 98:
      case 99:
        return FontAwesomeIcons.bolt;
      default:
        return FontAwesomeIcons.question;
    }
  }
}
