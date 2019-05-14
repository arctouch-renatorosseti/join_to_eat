import 'dart:ui';

class ScalerHelper {
  static const double MAX_PERCENT_OVER = 1.05;
  // Not used now, but it may be used in the future.
  static const double FONT_RATIO = 1.0;

  static Size _designSize;
  static Size _currentSize;

  static double _designArea;
  static double _currentArea;

  static void setDesignScreenSize(double width, double height) {
    _designSize = new Size(width, height);
    _designArea = width * height;
    _checkArea();
  }

  static void setCurrentScreenSize(double width, double height) {
    _currentSize = new Size(width, height);
    _currentArea = width * height;
    _checkArea();
  }

  static double getScaleWidth(double value) {
    return (_currentSize.width * value) / _designSize.width;
  }

  static double getScaleHeight(double value) {
    return (_currentSize.height * value) / _designSize.height;
  }

  static double getScaledValue(double value) {
    return (_currentArea * value) / _designArea;
  }

  static double getScaledFontSize(double fontSize) {
    return (_currentArea * fontSize * FONT_RATIO) / _designArea;
  }

  static Size getScaledSize(double width, double height) {
    return new Size(getScaleWidth(width), getScaleHeight(height));
  }

  static double screenWidth() {
    return _currentSize.width;
  }

  static double screenHeight() {
    return _currentSize.height;
  }

  static void _checkArea() {
    if (_designArea == null || _currentArea == null) {
      return;
    }

    if (_currentArea > _designArea * MAX_PERCENT_OVER) {
      _currentArea = _designArea * MAX_PERCENT_OVER;
      _currentSize = new Size(_designSize.width * MAX_PERCENT_OVER, _designSize.height * MAX_PERCENT_OVER);
    }
  }
}
