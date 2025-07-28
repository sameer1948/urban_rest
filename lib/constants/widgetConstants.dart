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

  static int formatDateTimeToInt() {
    final String formatted = DateFormat('yyMMddHHmmss').format(DateTime.now());
    return int.parse(formatted);
  }
}
