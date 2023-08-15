import 'package:flutter_riverpod/flutter_riverpod.dart';

final significantFiguresProvider = StateProvider<int>((ref) {
  return 10;
});

final removeTrailingZerosProvider = StateProvider<bool>((ref) {
  return true;
});
