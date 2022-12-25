import 'package:window_size/window_size.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:converterpro/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Large display test', () {
    testWidgets('Perform conversion, clear and undo',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      setWindowMinSize(const Size(800, 700));
      setWindowMaxSize(const Size(800, 700));
      await tester.pumpAndSettle();

      var tffFeet = find.byKey(const ValueKey('Feet')).evaluate().single.widget
          as TextFormField;
      var tffInches = find
          .byKey(const ValueKey('Inches'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffMeters = find
          .byKey(const ValueKey('Meters'))
          .evaluate()
          .single
          .widget as TextFormField;

      expect(find.text('Length'), findsNWidgets(2),
          reason: 'Expected the length page');

      await tester.enterText(find.byKey(const ValueKey('Feet')), '1');
      await tester.pumpAndSettle();

      expect(tffInches.controller!.text, '12', reason: 'Conversion error');
      expect(tffMeters.controller!.text, '0.3048', reason: 'Conversion error');

      await tester.tap(find.byKey(const ValueKey('clearAll')));
      await tester.pumpAndSettle();
      expect(tffFeet.controller!.text, '', reason: 'Text not cleared');
      expect(tffInches.controller!.text, '', reason: 'Text not cleared');
      expect(tffMeters.controller!.text, '', reason: 'Text not cleared');

      await tester.tap(find.byKey(const ValueKey('undoClearAll')));
      await tester.pumpAndSettle();
      expect(tffFeet.controller!.text, '1.0', reason: 'Text not restored');
      expect(tffInches.controller!.text, '12.0', reason: 'Text not restored');
      expect(tffMeters.controller!.text, '0.3048', reason: 'Text not restored');
    });
  });
}

/// Perform a long press drag from [start] to [end]. Useful for reorderable list
Future<void> longPressDrag(
    WidgetTester tester, Offset start, Offset end) async {
  final TestGesture drag = await tester.startGesture(start);
  await tester.pump(kLongPressTimeout + kPressTimeout);
  await drag.moveTo(end);
  await tester.pump(kPressTimeout);
  await drag.up();
}
