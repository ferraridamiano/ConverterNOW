import 'package:converterpro/styles/consts.dart';
import 'package:flutter/material.dart';

EdgeInsetsGeometry responsivePadding(double displayWidth) => EdgeInsets.symmetric(horizontal: displayWidth * 0.03);

int responsiveNumGridTiles(double deviceWidth) {
  if (deviceWidth < PIXEL_WIDTH_1_COLUMN) {
    return 1;
  } else if (deviceWidth < PIXEL_WIDTH_2_COLUMNS) {
    return 2;
  } else if (deviceWidth < PIXEL_WIDTH_3_COLUMNS) {
    return 3;
  }
  return 4;
}

double responsiveChildAspectRatio(double displayWidth) {
  double tileWidth = displayWidth * 0.97;
  if (displayWidth < PIXEL_WIDTH_1_COLUMN) {
    tileWidth = (tileWidth);
  } else if (displayWidth < PIXEL_WIDTH_2_COLUMNS) {
    tileWidth = (displayWidth - 15.0) / 2;
  } else if (displayWidth < PIXEL_WIDTH_3_COLUMNS) {
    tileWidth = (displayWidth - 30.0) / 3;
  } else {
    tileWidth = (displayWidth - 45.0) / 4;
  }

  return tileWidth / 107.0;
}

bool isDrawerFixed(double displayWidth) {
  return displayWidth > PIXEL_FIXED_DRAWER;
}
