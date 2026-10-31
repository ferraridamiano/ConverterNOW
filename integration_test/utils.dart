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
/// Since the reorderable grid starts the drag with a long press, the gesture
/// is held for [kLongPressTimeout] plus a small margin before moving.
Future<void> dragGesture(WidgetTester tester, Offset start, Offset end) async {
  final TestGesture drag = await tester.startGesture(start);
  await tester.pump(kLongPressTimeout + kPressTimeout);
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

/// Enters the units edit mode if needed, then drags the handle of [unitKey]
/// onto the center of [targetUnitKey].
Future<void> reorderUnit(
  WidgetTester tester,
  String unitKey,
  String targetUnitKey,
) async {
  if (find.byKey(const ValueKey('editUnits')).evaluate().isNotEmpty) {
    await tester.tap(find.byKey(const ValueKey('editUnits')));
    await tester.pumpAndSettle();
  }
  final dragHandle = tester.getCenter(
    find.byKey(ValueKey('unitDragHandle-$unitKey')),
  );
  final targetCenter = tester.getCenter(
    find.byKey(ValueKey('unit-$targetUnitKey')),
  );
  final TestGesture gesture = await tester.startGesture(dragHandle);
  await tester.pump();
  await gesture.moveTo(targetCenter);
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();
}

/// Leaves the units edit mode, scrolling back to the app bar if needed.
Future<void> exitUnitsEditMode(WidgetTester tester) async {
  await tester.fling(
    find.byType(CustomScrollView).first,
    const Offset(0, 1000),
    1000,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('saveUnits')));
  await tester.pumpAndSettle();
  // Let the asynchronous shared preferences write complete before a possible
  // app restart in the next test.
  await tester.pump(const Duration(milliseconds: 200));
}

/// Drags the property [propertyKey] (e.g. 'PROPERTYX.length') onto
/// [targetPropertyKey] while the drawer is in reorder mode.
Future<void> reorderProperty(
  WidgetTester tester,
  String propertyKey,
  String targetPropertyKey,
) async {
  final dragHandle = tester.getCenter(
    find.byKey(ValueKey('drawerReorderHandle_$propertyKey')),
  );
  final targetCenter = tester.getCenter(
    find.byKey(ValueKey('drawerReorderItem_$targetPropertyKey')),
  );
  await dragGesture(tester, dragHandle, targetCenter);
}

/// Gets the [TextFormField] widget for a given [key]
TextFormField getTextField(String key) =>
    find.byKey(ValueKey(key)).evaluate().single.widget as TextFormField;

/// Gets the current text value of a [TextFormField] with the given [key]
String getTextFieldText(String key) => getTextField(key).controller!.text;
