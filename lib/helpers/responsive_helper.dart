import 'package:flutter/material.dart';

const double PIXEL_WIDTH_1=750;
const double PIXEL_WIDTH_2=1200;
const double PIXEL_WIDTH_3=1650;


EdgeInsetsGeometry responsivePadding(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;
  return EdgeInsets.symmetric(horizontal: deviceWidth*0.03);
}

int responsiveNumGridTiles(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;
  if (deviceWidth < PIXEL_WIDTH_1) {
    return 1;
  } else if (deviceWidth < PIXEL_WIDTH_2) {
    return 2;
  } else if (deviceWidth < PIXEL_WIDTH_3) {
    return 3;
  }
  return 4;
}

double responsiveChildAspectRatio(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.width;
  double tileWidth=deviceWidth*0.97;
  if(deviceWidth < PIXEL_WIDTH_1){
    tileWidth=(tileWidth);
  }else if(deviceWidth < PIXEL_WIDTH_2){
    tileWidth=(deviceWidth-15.0)/2;
  }else if(deviceWidth < PIXEL_WIDTH_3){
    tileWidth=(deviceWidth-30.0)/3;
  }else{
    tileWidth=(deviceWidth-45.0)/4;
  }

  return tileWidth/107.0;
}