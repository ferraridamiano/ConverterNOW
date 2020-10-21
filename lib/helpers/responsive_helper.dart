import 'package:converterpro/styles/consts.dart';
import 'package:flutter/material.dart';

EdgeInsetsGeometry responsivePadding(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;
  return EdgeInsets.symmetric(horizontal: deviceWidth * 0.03);
}

int responsiveNumGridTiles(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;
  if (deviceWidth < PIXEL_WIDTH_1_COLUMN) {
    return 1;
  } else if (deviceWidth < PIXEL_WIDTH_2_COLUMNS) {
    return 2;
  } else if (deviceWidth < PIXEL_WIDTH_3_COLUMNS) {
    return 3;
  }
  return 4;
}

double responsiveChildAspectRatio(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;
  double tileWidth = deviceWidth * 0.97;
  if (deviceWidth < PIXEL_WIDTH_1_COLUMN) {
    tileWidth = (tileWidth);
  } else if (deviceWidth < PIXEL_WIDTH_2_COLUMNS) {
    tileWidth = (deviceWidth - 15.0) / 2;
  } else if (deviceWidth < PIXEL_WIDTH_3_COLUMNS) {
    tileWidth = (deviceWidth - 30.0) / 3;
  } else {
    tileWidth = (deviceWidth - 45.0) / 4;
  }

  return tileWidth / 107.0;
}
