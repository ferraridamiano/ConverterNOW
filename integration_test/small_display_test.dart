import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:converterpro/main.dart' as app;
import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> testInit(
    WidgetTester tester, {
    bool clearPrefs = true,
    bool openFirstProperty = true,
  }) async {
    if (clearPrefs) {
      await clearPreferences();
    }
    app.main();
    await tester.pumpAndSettle();
    setWindowSize(400, 800);
    await tester.pumpAndSettle();
    if (openFirstProperty) {
      await tester.tap(find.byKey(const ValueKey('gridtile-0')));
      await tester.pumpAndSettle();
    }
  }

  group('Common conversions tasks:', () {
    testWidgets('Change to a new property and perform conversion', (
      WidgetTester tester,
    ) async {
      await testInit(tester, openFirstProperty: false);
      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('drawerItem_PROPERTYX.currencies')),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Currencies'),
        findsAtLeastNWidgets(1),
        reason: 'Expected the currencies page',
      );
      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('drawerItem_PROPERTYX.area')));
      await tester.pumpAndSettle();
      expect(
        find.text('Area'),
        findsAtLeastNWidgets(1),
        reason: 'Expected the area page',
      );

      await tester.enterText(
        find.byKey(const ValueKey('AREA.squareFeet')),
        '1000',
      );
      await tester.pumpAndSettle();

      expect(
        getTextFieldText('AREA.hectares'),
        '0.009290304',
        reason: 'Conversion error',
      );
      expect(
        getTextFieldText('AREA.squareMeters'),
        '92.90304',
        reason: 'Conversion error',
      );

      await tester.tap(find.byKey(const ValueKey('clearAll')));
      await tester.pumpAndSettle();
      expect(getTextFieldText('AREA.squareFeet'), '', reason: 'Text not cleared');
      expect(getTextFieldText('AREA.hectares'), '', reason: 'Text not cleared');
      expect(getTextFieldText('AREA.squareMeters'), '', reason: 'Text not cleared');
    });
  });

  testWidgets('Perform conversion, clear and undo', (
    WidgetTester tester,
  ) async {
    await testInit(tester);

    expect(
      find.text('Length'),
      findsAtLeastNWidgets(1),
      reason: 'Expected the length page',
    );

    await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '1');
    await tester.pumpAndSettle();

    expect(getTextFieldText('LENGTH.feet'), '5280', reason: 'Conversion error');
    expect(getTextFieldText('LENGTH.meters'), '1609.344', reason: 'Conversion error');

    await tester.tap(find.byKey(const ValueKey('clearAll')));
    await tester.pumpAndSettle();
    expect(getTextFieldText('LENGTH.miles'), '', reason: 'Text not cleared');
    expect(getTextFieldText('LENGTH.feet'), '', reason: 'Text not cleared');
    expect(getTextFieldText('LENGTH.meters'), '', reason: 'Text not cleared');

    await tester.tap(find.byKey(const ValueKey('undoClearAll')));
    await tester.pumpAndSettle();
    expect(getTextFieldText('LENGTH.miles'), '1.0', reason: 'Text not restored');
    expect(getTextFieldText('LENGTH.feet'), '5280.0', reason: 'Text not restored');
    expect(getTextFieldText('LENGTH.meters'), '1609.344', reason: 'Text not restored');
  });

  group('Language tasks:', () {
    testWidgets('Change language', (WidgetTester tester) async {
      await testInit(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('drawerItem_settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('language-dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Italiano').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lunghezza'));
      await tester.pumpAndSettle();
      expect(
        find.text('Lunghezza'),
        findsAtLeastNWidgets(1),
        reason: 'Expected translated string',
      );
    });
    testWidgets('Check if language has been saved', (
      WidgetTester tester,
    ) async {
      await testInit(tester, clearPrefs: false);
      expect(
        find.text('Lunghezza'),
        findsAtLeastNWidgets(1),
        reason: 'Expected translated string',
      );
      await clearPreferences();
    });
  });

  group('Reordering tasks:', () {
    testWidgets('Reorder units', (WidgetTester tester) async {
      await testInit(tester);

      // At the beginning the ordering is Meters, Centimeters, Inches, ...
      expect(
        tester.getCenter(find.text('Meters')).dy <
                tester.getCenter(find.text('Feet')).dy &&
            tester.getCenter(find.text('Yards')).dy <
                tester.getCenter(find.text('Kilometers')).dy,
        true,
        reason: 'Initial ordering of length units is not what expected',
      );

      // Drag the Meters tile onto the Yards tile
      await dragGesture(
        tester,
        tester.getCenter(find.text('Meters')),
        tester.getCenter(find.text('Yards')),
      );
      await tester.pumpAndSettle();

      // Drag the Kilometers tile onto the Feet tile
      await dragGesture(
        tester,
        tester.getCenter(find.text('Kilometers')),
        tester.getCenter(find.text('Feet')),
      );
      await tester.pumpAndSettle();

      // Now the ordering should be ... Kilometers, Feet, Meters ...
      expect(
        tester.getCenter(find.text('Kilometers')).dy <
                tester.getCenter(find.text('Feet')).dy &&
            tester.getCenter(find.text('Feet')).dy <
                tester.getCenter(find.text('Meters')).dy,
        true,
        reason: 'Final ordering of length units is not what expected',
      );
    });

    testWidgets('Check if units ordering has been saved', (
      WidgetTester tester,
    ) async {
      await testInit(tester, clearPrefs: false);

      expect(
        tester.getCenter(find.text('Kilometers')).dy <
                tester.getCenter(find.text('Feet')).dy &&
            tester.getCenter(find.text('Feet')).dy <
                tester.getCenter(find.text('Meters')).dy,
        true,
        reason: 'Ordering of length units is not what expected',
      );
    });

    testWidgets('Reorder properties', (WidgetTester tester) async {
      await testInit(tester);

      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();
      // At the beginning the ordering is Length, Area, Volume, ...
      expect(
        tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.length')),
                    )
                    .dy <
                tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.area')),
                    )
                    .dy &&
            tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.area')),
                    )
                    .dy <
                tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.volume')),
                    )
                    .dy,
        true,
        reason: 'Initial ordering of properties is not what expected',
      );

      await tester.tap(find.byKey(const ValueKey('drawerItem_settings')));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('reorder-properties')));
      await tester.pumpAndSettle();

      final xDragHandle = tester
          .getCenter(find.byIcon(Icons.drag_handle).first)
          .dx;

      await dragGesture(
        tester,
        Offset(xDragHandle, tester.getCenter(find.text('Length').last).dy),
        Offset(xDragHandle, tester.getCenter(find.text('Currencies').last).dy),
      );
      await tester.pumpAndSettle();

      await dragGesture(
        tester,
        Offset(xDragHandle, tester.getCenter(find.text('Volume').last).dy),
        Offset(xDragHandle, tester.getCenter(find.text('Area').last).dy),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('confirm')));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();

      // Now the ordering should be Volume, Area, Length, ...
      expect(
        tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.length')),
                    )
                    .dy >
                tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.area')),
                    )
                    .dy &&
            tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.area')),
                    )
                    .dy >
                tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.volume')),
                    )
                    .dy,
        true,
        reason: 'Final ordering the of properties is not what expected',
      );
    });

    testWidgets('Check if properties ordering has been saved', (
      WidgetTester tester,
    ) async {
      await testInit(tester, clearPrefs: false);
      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();
      expect(
        tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.length')),
                    )
                    .dy >
                tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.area')),
                    )
                    .dy &&
            tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.area')),
                    )
                    .dy >
                tester
                    .getCenter(
                      find.byKey(const ValueKey('drawerItem_PROPERTYX.volume')),
                    )
                    .dy,
        true,
        reason: 'Ordering of the properties is not what expected',
      );
    });
  });

  group('Conversion after reorder:', () {
    testWidgets('Change the order of properties and units and convert', (
      WidgetTester tester,
    ) async {
      await testInit(tester);

      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('drawerItem_settings')));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('reorder-properties')));
      await tester.pumpAndSettle();

      final xDragHandleProperties = tester
          .getCenter(find.byIcon(Icons.drag_handle).first)
          .dx;

      await dragGesture(
        tester,
        Offset(
          xDragHandleProperties,
          tester.getCenter(find.text('Length').last).dy,
        ),
        Offset(
          xDragHandleProperties,
          tester.getCenter(find.text('Currencies').last).dy,
        ),
      );
      await tester.pumpAndSettle();

      await dragGesture(
        tester,
        Offset(
          xDragHandleProperties,
          tester.getCenter(find.text('Volume').last).dy,
        ),
        Offset(
          xDragHandleProperties,
          tester.getCenter(find.text('Area').last).dy,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('confirm')));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('drawerItem_PROPERTYX.length')),
      );
      await tester.pumpAndSettle();

      // Drag the Meters tile onto the Yards tile
      await dragGesture(
        tester,
        tester.getCenter(find.text('Meters')),
        tester.getCenter(find.text('Yards')),
      );
      await tester.pumpAndSettle();

      // Drag the Kilometers tile onto the Feet tile
      await dragGesture(
        tester,
        tester.getCenter(find.text('Kilometers')),
        tester.getCenter(find.text('Feet')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '1');
      await tester.pumpAndSettle();

      expect(
        getTextFieldText('LENGTH.feet'),
        '5280',
        reason: 'Conversion error',
      );
      expect(
        getTextFieldText('LENGTH.meters'),
        '1609.344',
        reason: 'Conversion error',
      );
    });

    testWidgets('Check if it is capable of the same conversion after restart', (
      WidgetTester tester,
    ) async {
      await testInit(tester, clearPrefs: false);

      await tester.tap(find.byIcon(Icons.menu)); // Open drawer
      await tester.pumpAndSettle();

      await tester.tap(find.text('Length'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '1');
      await tester.pumpAndSettle();

      expect(
        getTextFieldText('LENGTH.feet'),
        '5280',
        reason: 'Conversion error',
      );
      expect(
        getTextFieldText('LENGTH.meters'),
        '1609.344',
        reason: 'Conversion error',
      );
    });
  });
}
