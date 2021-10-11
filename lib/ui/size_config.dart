import 'dart:ui';

class SizeConfig {
  static double w = 0;
  static double h = 0;
  static double ww = 0;
  static double hh = 0;
  static void init(Size size) {
    w = size.width;
    h = size.height;
    ww = w / 10;
    hh = h / 10;
  }
}
