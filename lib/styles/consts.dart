const double SINGLE_PAGE_FIXED_HEIGHT = 650;
const double SINGLE_PAGE_TEXT_SIZE = 18.0;
/// trigger from classic drawer to drawer fixed open
const double PIXEL_FIXED_DRAWER = 650;
/// trigger from 1 column  to 2 columns (just inner view). Should be greater than `PIXEL_FIXED_DRAWER`
const double PIXEL_WIDTH_1_COLUMN = 700;
/// trigger from 2 columns to 3 columns (just inner view). Should be greater than `PIXEL_WIDTH_1_COLUMN`
const double PIXEL_WIDTH_2_COLUMNS = 1000;
/// trigger from 3 columns to 4 columns (just inner view). Should be greater than `PIXEL_WIDTH_2_COLUMNS`
const double PIXEL_WIDTH_3_COLUMNS = 1300;
/// trigger from 1 page reorder screen to 2 pages reorder screen (just inner view). Should be greater than
/// `PIXEL_FIXED_DRAWER`
const double TWO_SIDED_REORDER_SCREEN = 700;