import 'dart:ui';

/// This service helps to make the UI responsive and clean....
class Responsiveness {
  /// My final screen size....
  static final Size _size = Size(360.0, 728.0);

  static Size screenSize = Size(0, 0);

  /// Call this init function on the first build method as passing the MediaQuery.of(context).size....
  /// ```
  /// Responsiveness.init(MediaQuery.of(context).size);
  /// ```
  static init(Size size) {
    screenSize = size;
  }

  /// You can pass the fixed size width value it will automatically responsive for other mobile....
  /// ```
  /// Responsiveness.width(150),
  /// ```
  static double width(value) {
    return screenSize.width * (value / _size.width);
  }

  /// You can pass the fixed size height value it will automatically responsive for other mobile....
  /// ```
  /// Responsiveness.height(150),
  /// ```
  static double height(value) {
    return screenSize.height * (value / _size.height);
  }

  /// You can pass the ratio size width value it will automatically responsive for other mobile....
  /// ```
  /// Responsiveness.widthRatio(0.5),
  /// ```
  static double widthRatio(value) {
    return screenSize.width * value;
  }

  /// You can pass the ratio size height value it will automatically responsive for other mobile....
  /// ```
  /// Responsiveness.heightRatio(0.5),
  /// ```
  static double heightRatio(value) {
    return screenSize.height * value;
  }
}
