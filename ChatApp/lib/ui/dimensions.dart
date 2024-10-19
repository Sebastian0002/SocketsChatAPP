import 'package:flutter/material.dart';


class Responsive {
  // static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  double _screenHeight = 0.0;
  double get screenHeight => _screenHeight;
  double _screenWidth = 0.0;
  double get screenWidth => _screenWidth;
  Size _screenSize = Size.zero;
  static const _widthDefault = 390;
  static const _heightDefault = 844;

  void initResponsive(BuildContext context){
    _screenSize = MediaQuery.of(context).size;
    _screenHeight = _screenSize.height;
    _screenWidth = _screenSize.width;
  }

  double get scaleWidth => _screenWidth / _widthDefault;
  double get scaleHeight => _screenHeight / _heightDefault;
  double get scaleAverage => ((_screenWidth / _widthDefault)+( _screenHeight / _heightDefault))/2;
  double get aspectRatio => _screenWidth / _screenHeight;
}

Responsive responsive = Responsive();