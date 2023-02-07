import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clears the saved shared preferences
clearPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
}

/// Perform a drag from [start] to [end]. Useful for reorderable list
Future<void> dragGesture(WidgetTester tester, Offset start, Offset end) async {
  final TestGesture drag = await tester.startGesture(start);
  await tester.pump(kPressTimeout);
  await drag.moveTo(end);
  await tester.pump(kPressTimeout);
  await drag.up();
}
