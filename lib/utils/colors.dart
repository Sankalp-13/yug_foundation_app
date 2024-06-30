import 'dart:ui';

import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}


MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;
  final int alpha = color.alpha;

  final Map<int, Color> shades = {
    50: Color.fromARGB(alpha, red, green, blue),
    100: Color.fromARGB(alpha, red, green, blue),
    200: Color.fromARGB(alpha, red, green, blue),
    300: Color.fromARGB(alpha, red, green, blue),
    400: Color.fromARGB(alpha, red, green, blue),
    500: Color.fromARGB(alpha, red, green, blue),
    600: Color.fromARGB(alpha, red, green, blue),
    700: Color.fromARGB(alpha, red, green, blue),
    800: Color.fromARGB(alpha, red, green, blue),
    900: Color.fromARGB(alpha, red, green, blue),
  };

  return MaterialColor(color.value, shades);
}

class ColorConstants {
  static Color mainThemeColor = hexToColor('#9c2741');
  static Color lightWidgetColor = hexToColor('#eeb6c3');
  static Color darkWidgetColor = hexToColor('#cf3e5f');
  static Color accentColor = hexToColor('#bee2d4');

}



// static Color mainThemeColor = hexToColor('#9c2741');
// static Color lightWidgetColor = hexToColor('#eeb6c3');
// static Color darkWidgetColor = hexToColor('#cf3e5f');
// static Color accentColor = hexToColor('#bee2d4');


// Color darkAccent = const Color(0xFFe84444);#EDCD8B
