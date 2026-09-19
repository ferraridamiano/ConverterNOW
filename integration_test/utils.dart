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
///
/// The movement is split into steps so that the reorderable widgets receive
/// intermediate pointer move events while dragging.
Future<void> dragGesture(WidgetTester tester, Offset start, Offset end) async {
  final TestGesture drag = await tester.startGesture(start);
  await tester.pump(kPressTimeout);
  const int steps = 5;
  for (int i = 1; i <= steps; i++) {
    await drag.moveTo(Offset.lerp(start, end, i / steps)!);
    await tester.pump(kPressTimeout);
  }
  await drag.up();
  await tester.pump(kPressTimeout);
}

/// Sets the window size
void setWindowSize(double width, double height) {
  final size = Size(width, height);
  setWindowMinSize(size);
  setWindowMaxSize(size);
}

/// Focuses on [unitKey] to reveal its drag handle, then drags it to the center of [targetUnitKey]
Future<void> reorderUnit(
  WidgetTester tester,
  String unitKey,
  String targetUnitKey,
) async {
  await tester.tap(find.byKey(ValueKey(unitKey)));
  await tester.pumpAndSettle();
  final dragHandle = tester.getCenter(find.byIcon(Icons.drag_handle));
  final targetCenter = tester.getCenter(find.byKey(ValueKey(targetUnitKey)));
  await dragGesture(tester, dragHandle, targetCenter);
  await tester.pumpAndSettle();
}

/// Gets the [TextFormField] widget for a given [key]
TextFormField getTextField(String key) =>
    find.byKey(ValueKey(key)).evaluate().single.widget as TextFormField;

/// Gets the current text value of a [TextFormField] with the given [key]
String getTextFieldText(String key) => getTextField(key).controller!.text;
