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

      var tffFeet = find
          .byKey(const ValueKey('LENGTH.feet'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffInches = find
          .byKey(const ValueKey('LENGTH.inches'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffMeters = find
          .byKey(const ValueKey('LENGTH.meters'))
          .evaluate()
          .single
          .widget as TextFormField;

      expect(find.text('Length'), findsNWidgets(2),
          reason: 'Expected the length page');

      await tester.enterText(find.byKey(const ValueKey('LENGTH.feet')), '1');
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

    testWidgets('Change to a new property and perform conversion',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('drawerItem_currencies')));
      await tester.pumpAndSettle();
      expect(find.text('Currencies'), findsNWidgets(2),
          reason: 'Expected the currencies page');
      await tester.tap(find.byKey(const ValueKey('drawerItem_area')));
      await tester.pumpAndSettle();
      expect(find.text('Area'), findsNWidgets(2),
          reason: 'Expected the area page');

      var tffInches = find
          .byKey(const ValueKey('AREA.squareInches'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffCentimeters = find
          .byKey(const ValueKey('AREA.squareCentimeters'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffMeters = find
          .byKey(const ValueKey('AREA.squareMeters'))
          .evaluate()
          .single
          .widget as TextFormField;

      await tester.enterText(
          find.byKey(const ValueKey('AREA.squareInches')), '1');
      await tester.pumpAndSettle();

      expect(tffCentimeters.controller!.text, '6.4516',
          reason: 'Conversion error');
      expect(tffMeters.controller!.text, '0.00064516',
          reason: 'Conversion error');

      await tester.tap(find.byKey(const ValueKey('clearAll')));
      await tester.pumpAndSettle();
      expect(tffInches.controller!.text, '', reason: 'Text not cleared');
      expect(tffCentimeters.controller!.text, '', reason: 'Text not cleared');
      expect(tffMeters.controller!.text, '', reason: 'Text not cleared');
    });

    testWidgets('Reorder units', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // At the beginning the ordering is Meters, Centimeters, Inches, ...
      expect(
        tester.getCenter(find.text('Meters')).dy <
                tester.getCenter(find.text('Centimeters')).dy &&
            tester.getCenter(find.text('Centimeters')).dy <
                tester.getCenter(find.text('Inches')).dy,
        true,
        reason: 'Initial ordering of length units is not what expected',
      );

      await tester.tap(find.byKey(const ValueKey('drawerItem_settings')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('reorder-units')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('chooseProperty-length')));
      await tester.pumpAndSettle();

      final xDragHadle =
          tester.getCenter(find.byIcon(Icons.drag_handle).first).dx;

      await longPressDrag(
        tester,
        Offset(xDragHadle, tester.getCenter(find.text('Meters')).dy),
        Offset(xDragHadle, tester.getCenter(find.text('Feet')).dy),
      );
      await tester.pumpAndSettle();

      await longPressDrag(
        tester,
        Offset(xDragHadle, tester.getCenter(find.text('Inches')).dy),
        Offset(xDragHadle, tester.getCenter(find.text('Centimeters')).dy),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('confirm')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Length'));
      await tester.pumpAndSettle();

      // Now the ordering should be Inches, Centimeters, Meters, ...
      expect(
        tester.getCenter(find.text('Meters')).dy >
                tester.getCenter(find.text('Centimeters')).dy &&
            tester.getCenter(find.text('Centimeters')).dy >
                tester.getCenter(find.text('Inches')).dy,
        true,
        reason: 'Final ordering of length units is not what expected',
      );
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
