import 'dart:ui';

class ResponsiveService {
  static final Size _size = Size(360.0, 728.0);
  static Size screenSize = Size(0, 0);
  static double width(value) {
    return screenSize.width * (value / _size.width);
  }

  static double height(value) {
    return screenSize.height * (value / _size.height);
  }

  static double widthRatio(value) {
    return screenSize.width * value;
  }

  static double heightRatio(value) {
    return screenSize.height * value;
  }
}
