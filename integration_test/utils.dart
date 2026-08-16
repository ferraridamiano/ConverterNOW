import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

/// Clears the saved shared preferences
Future<void> clearPreferences() async {
  final pref = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
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

/// Sets the window size
void setWindowSize(double width, double height) {
  final size = Size(width, height);
  setWindowMinSize(size);
  setWindowMaxSize(size);
}

/// Gets the [TextFormField] widget for a given [key]
TextFormField getTextField(String key) =>
    find.byKey(ValueKey(key)).evaluate().single.widget as TextFormField;

/// Gets the current text value of a [TextFormField] with the given [key]
String getTextFieldText(String key) => getTextField(key).controller!.text;
