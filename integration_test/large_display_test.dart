import 'package:window_size/window_size.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:converterpro/main.dart' as app;
import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Sets the window size
  void setWindowSize({Size size = const Size(800, 700)}) {
    setWindowMinSize(size);
    setWindowMaxSize(size);
  }

  group('Common conversions tasks', () {
    testWidgets('Perform conversion, clear and undo',
        (WidgetTester tester) async {
      await clearPreferences();
      app.main();
      await tester.pumpAndSettle();
      setWindowSize();
      await tester.pumpAndSettle();

      final tffMiles = find
          .byKey(const ValueKey('LENGTH.miles'))
          .evaluate()
          .single
          .widget as TextFormField;
      final tffFeet = find
          .byKey(const ValueKey('LENGTH.feet'))
          .evaluate()
          .single
          .widget as TextFormField;
      final tffMeters = find
          .byKey(const ValueKey('LENGTH.meters'))
          .evaluate()
          .single
          .widget as TextFormField;

      expect(find.text('Length'), findsAtLeastNWidgets(2),
          reason: 'Expected the length page');

      await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '1');
      await tester.pumpAndSettle();

      expect(tffFeet.controller!.text, '5280', reason: 'Conversion error');
      expect(tffMeters.controller!.text, '1609.344',
          reason: 'Conversion error');

      await tester.tap(find.byKey(const ValueKey('clearAll')));
      await tester.pumpAndSettle();
      expect(tffMiles.controller!.text, '', reason: 'Text not cleared');
      expect(tffFeet.controller!.text, '', reason: 'Text not cleared');
      expect(tffMeters.controller!.text, '', reason: 'Text not cleared');

      await tester.tap(find.byKey(const ValueKey('undoClearAll')));
      await tester.pumpAndSettle();
      expect(tffMiles.controller!.text, '1.0', reason: 'Text not restored');
      expect(tffFeet.controller!.text, '5280.0', reason: 'Text not restored');
      expect(tffMeters.controller!.text, '1609.344',
          reason: 'Text not restored');
    });

    testWidgets('Change to a new property and perform conversion',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const ValueKey('drawerItem_PROPERTYX.currencies')));
      await tester.pumpAndSettle();
      expect(find.text('Currencies'), findsAtLeastNWidgets(2),
          reason: 'Expected the currencies page');
      await tester.tap(find.byKey(const ValueKey('drawerItem_PROPERTYX.area')));
      await tester.pumpAndSettle();
      expect(find.text('Area'), findsAtLeastNWidgets(2),
          reason: 'Expected the area page');

      var tffFeet = find
          .byKey(const ValueKey('AREA.squareFeet'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffHectares = find
          .byKey(const ValueKey('AREA.hectares'))
          .evaluate()
          .single
          .widget as TextFormField;
      var tffMeters = find
          .byKey(const ValueKey('AREA.squareMeters'))
          .evaluate()
          .single
          .widget as TextFormField;

      await tester.enterText(
          find.byKey(const ValueKey('AREA.squareFeet')), '1000');
      await tester.pumpAndSettle();

      expect(tffHectares.controller!.text, '0.009290304',
          reason: 'Conversion error');
      expect(tffMeters.controller!.text, '92.90304',
          reason: 'Conversion error');

      await tester.tap(find.byKey(const ValueKey('clearAll')));
      await tester.pumpAndSettle();
      expect(tffFeet.controller!.text, '', reason: 'Text not cleared');
      expect(tffHectares.controller!.text, '', reason: 'Text not cleared');
      expect(tffMeters.controller!.text, '', reason: 'Text not cleared');
    });
  });

  group('Language tasks', () {
    testWidgets('Change language', (WidgetTester tester) async {
      await clearPreferences();
      app.main();
      await tester.pumpAndSettle();
      setWindowSize();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('drawerItem_settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('language-dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Italiano').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lunghezza'));
      await tester.pumpAndSettle();
      expect(find.text('Lunghezza'), findsAtLeastNWidgets(2),
          reason: 'Expected translated string');
    });
    testWidgets('Check if language has been saved',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('Lunghezza'), findsAtLeastNWidgets(2),
          reason: 'Expected translated string');
      await clearPreferences();
    });
  });

  group('Reordering tasks', () {
    testWidgets('Reorder units', (WidgetTester tester) async {
      await clearPreferences();

      app.main();
      await tester.pumpAndSettle();
      setWindowSize();
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

      await dragGesture(
        tester,
        Offset(xDragHadle, tester.getCenter(find.text('Meters')).dy),
        Offset(xDragHadle, tester.getCenter(find.text('Feet')).dy),
      );
      await tester.pumpAndSettle();

      await dragGesture(
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

    testWidgets('Check if units ordering has been saved',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(
        tester.getCenter(find.text('Meters')).dy >
                tester.getCenter(find.text('Centimeters')).dy &&
            tester.getCenter(find.text('Centimeters')).dy >
                tester.getCenter(find.text('Inches')).dy,
        true,
        reason: 'Ordering of length units is not what expected',
      );
    });

    testWidgets('Reorder properties', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // At the beginning the ordering is Length, Area, Volume, ...
      expect(
        tester.getCenter(find.byKey(const ValueKey('drawerItem_length'))).dy <
                tester
                    .getCenter(find.byKey(const ValueKey('drawerItem_area')))
                    .dy &&
            tester.getCenter(find.byKey(const ValueKey('drawerItem_area'))).dy <
                tester
                    .getCenter(find.byKey(const ValueKey('drawerItem_volume')))
                    .dy,
        true,
        reason: 'Initial ordering of properties is not what expected',
      );

      await tester.tap(find.byKey(const ValueKey('drawerItem_settings')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('reorder-properties')));
      await tester.pumpAndSettle();

      final xDragHadle =
          tester.getCenter(find.byIcon(Icons.drag_handle).first).dx;

      await dragGesture(
        tester,
        Offset(xDragHadle, tester.getCenter(find.text('Length').last).dy),
        Offset(xDragHadle, tester.getCenter(find.text('Currencies').last).dy),
      );
      await tester.pumpAndSettle();

      await dragGesture(
        tester,
        Offset(xDragHadle, tester.getCenter(find.text('Volume').last).dy),
        Offset(xDragHadle, tester.getCenter(find.text('Area').last).dy),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('confirm')));
      await tester.pumpAndSettle();

      // Now the ordering should be Volume, Area, Length, ...
      expect(
        tester.getCenter(find.byKey(const ValueKey('drawerItem_length'))).dy >
                tester
                    .getCenter(find.byKey(const ValueKey('drawerItem_area')))
                    .dy &&
            tester.getCenter(find.byKey(const ValueKey('drawerItem_area'))).dy >
                tester
                    .getCenter(find.byKey(const ValueKey('drawerItem_volume')))
                    .dy,
        true,
        reason: 'Final ordering the of properties is not what expected',
      );
    });

    testWidgets('Check if properties ordering has been saved',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(
        tester.getCenter(find.byKey(const ValueKey('drawerItem_length'))).dy >
                tester
                    .getCenter(find.byKey(const ValueKey('drawerItem_area')))
                    .dy &&
            tester.getCenter(find.byKey(const ValueKey('drawerItem_area'))).dy >
                tester
                    .getCenter(find.byKey(const ValueKey('drawerItem_volume')))
                    .dy,
        true,
        reason: 'Ordering of the properties is not what expected',
      );
    });
  });
}
