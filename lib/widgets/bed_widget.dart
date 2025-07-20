import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class BedWidget {
  static SvgPicture getBedIcon(
    String path,
    Color color,
    double width,
    double height,
  ) {
    return SvgPicture.asset(path, color: color, width: width, height: height);
  }
}
