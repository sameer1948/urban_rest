// ignore_for_file: file_names, constant_identifier_names

import 'package:intl/intl.dart';

class Widgetconstants {
  static const String APPLICATION_ICON = 'assets/icon/icon.png';
  static const String BED_ICON = 'assets/svg/bed.svg';

  static const List<String> transitionStyles = [
    'fade',
    'slide',
    'slide_left',
    'slide_up',
    'slide_down',
    'scale',
    'rotation',
    'slide_fade',
    'scale_fade',
    'rotation_scale',
    'flip_horizontal',
    'flip_vertical',
  ];

  static const Map<String, String> durationOptions = {
    '1': '1 Hour',
    '2': '2 Hours',
    '4': '4 Hours',
    '8': '8 Hours',
    '12': 'Overnight',
    '24': 'Day',
  };

  static const Map<String, String> backgroundColors = {
    'Color - 1': '0xFFf3e7e9,0xFFe3eeff',
    'Color - 2': '0xFFdcb0ed,0xFF99c99c',
    'Color - 3': '0xFFddd6f3,0xFFfaaca8',
    'Color - 4': '0xFFabecd6,0xFFfbed96',
    'Color - 5': '0xFFd9afd9,0xFF97d9e1',
    'Color - 6': '0xFF9795f0,0xFFfbc8d4',
    'Color - 7': '0xFF9795f0,0xFFfbc8d4',
    'Color - 8': '0xFFc1dfc4,0xFFdeecdd',
    'Color - 9': '0xFFfdcbf1,0xFFe6dee9',
  };

  static int formatDateTimeToInt() {
    final String formatted = DateFormat('yyMMddHHmmss').format(DateTime.now());
    return int.parse(formatted);
  }
}
