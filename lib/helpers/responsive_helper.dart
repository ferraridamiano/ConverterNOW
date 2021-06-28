import 'package:converterpro/styles/consts.dart';

double responsivePadding(double displayWidth) => displayWidth * 0.03;

int responsiveNumGridTiles(double displayWidth) {
  if (displayWidth < PIXEL_WIDTH_1_COLUMN) {
    return 1;
  } else if (displayWidth < PIXEL_WIDTH_2_COLUMNS) {
    return 2;
  } else if (displayWidth < PIXEL_WIDTH_3_COLUMNS) {
    return 3;
  }
  return 4;
}

double responsiveChildAspectRatio(double displayWidth) {
  int colNumber = responsiveNumGridTiles(displayWidth);
  double tileWidth = 0.97 * (displayWidth - (isDrawerFixed(displayWidth) ? 300 : 0)) / colNumber;
  return tileWidth / 110;
}

bool isDrawerFixed(double displayWidth) => displayWidth > PIXEL_FIXED_DRAWER;
