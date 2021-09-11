import 'package:converterpro/styles/consts.dart';

double responsivePadding(double displayWidth) => displayWidth * 0.03;

int responsiveNumCols(double displayWidth) {
  if (displayWidth < PIXEL_WIDTH_1_COLUMN) {
    return 1;
  } else if (displayWidth < PIXEL_WIDTH_2_COLUMNS) {
    return 2;
  } else if (displayWidth < PIXEL_WIDTH_3_COLUMNS) {
    return 3;
  }
  return 4;
}

double responsiveChildAspectRatio(double width, int colNumber) => width / (colNumber * 110);

bool isDrawerFixed(double displayWidth) => displayWidth > PIXEL_FIXED_DRAWER;
