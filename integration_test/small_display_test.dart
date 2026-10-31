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
      expect(
        getTextFieldText('AREA.squareFeet'),
        '',
        reason: 'Text not cleared',
      );
      expect(getTextFieldText('AREA.hectares'), '', reason: 'Text not cleared');
      expect(
        getTextFieldText('AREA.squareMeters'),
        '',
        reason: 'Text not cleared',
      );
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
    expect(
      getTextFieldText('LENGTH.meters'),
      '1609.344',
      reason: 'Conversion error',
    );

    await tester.tap(find.byKey(const ValueKey('clearAll')));
    await tester.pumpAndSettle();
    expect(getTextFieldText('LENGTH.miles'), '', reason: 'Text not cleared');
    expect(getTextFieldText('LENGTH.feet'), '', reason: 'Text not cleared');
    expect(getTextFieldText('LENGTH.meters'), '', reason: 'Text not cleared');

    await tester.tap(find.byKey(const ValueKey('undoClearAll')));
    await tester.pumpAndSettle();
    expect(
      getTextFieldText('LENGTH.miles'),
      '1.0',
      reason: 'Text not restored',
    );
    expect(
      getTextFieldText('LENGTH.feet'),
      '5280.0',
      reason: 'Text not restored',
    );
    expect(
      getTextFieldText('LENGTH.meters'),
      '1609.344',
      reason: 'Text not restored',
    );
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
    testWidgets('Change language updates the decimal separator', (
      WidgetTester tester,
    ) async {
      await testInit(tester);
      // Perform a conversion with a decimal result
      await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '1');
      await tester.pumpAndSettle();
      expect(
        getTextFieldText('LENGTH.meters'),
        '1609.344',
        reason: 'Conversion error',
      );
      // Switch to Italian: the decimal separator should change from '.' to ','
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
        getTextFieldText('LENGTH.meters'),
        '1609,344',
        reason: 'Expected the Italian decimal separator',
      );
      // Converting again should still work
      await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '2');
      await tester.pumpAndSettle();
      expect(
        getTextFieldText('LENGTH.meters'),
        '3218,688',
        reason: 'Conversion error with the Italian decimal separator',
      );
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

      await reorderUnit(tester, 'LENGTH.meters', 'LENGTH.yards');
      await reorderUnit(tester, 'LENGTH.kilometers', 'LENGTH.feet');
      await exitUnitsEditMode(tester);

      // Now the ordering should be Inches, Centimeters, Meters, ...
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

    testWidgets('Edit units mode shows the drag handles', (
      WidgetTester tester,
    ) async {
      await testInit(tester);

      expect(
        find.byKey(const ValueKey('unitDragHandle-LENGTH.meters')),
        findsNothing,
      );

      await tester.tap(find.byKey(const ValueKey('editUnits')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('unitDragHandle-LENGTH.meters')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('unitVisibilityHandle-LENGTH.meters')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('saveUnits')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('unitDragHandle-LENGTH.meters')),
        findsNothing,
      );
    });

    testWidgets('Convert while editing units', (WidgetTester tester) async {
      await testInit(tester);

      await tester.tap(find.byKey(const ValueKey('editUnits')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('LENGTH.miles')), '1');
      await tester.pumpAndSettle();

      expect(
        getTextFieldText('LENGTH.feet'),
        '5280',
        reason: 'Conversion error while editing units',
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

      await tester.tap(find.byKey(const ValueKey('drawerEditProperties')));
      await tester.pumpAndSettle();

      await reorderProperty(tester, 'PROPERTYX.length', 'PROPERTYX.currencies');
      await tester.pumpAndSettle();

      await reorderProperty(tester, 'PROPERTYX.volume', 'PROPERTYX.area');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('drawerSaveProperties')));
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

      await tester.tap(find.byKey(const ValueKey('drawerEditProperties')));
      await tester.pumpAndSettle();

      await reorderProperty(tester, 'PROPERTYX.length', 'PROPERTYX.currencies');
      await tester.pumpAndSettle();

      await reorderProperty(tester, 'PROPERTYX.volume', 'PROPERTYX.area');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('drawerSaveProperties')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('drawerItem_PROPERTYX.length')),
      );
      await tester.pumpAndSettle();

      await reorderUnit(tester, 'LENGTH.meters', 'LENGTH.yards');
      await reorderUnit(tester, 'LENGTH.kilometers', 'LENGTH.feet');
      await exitUnitsEditMode(tester);

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

  group('Search tasks:', () {
    // Opens the search page through the bottom app bar button, performs a
    // [query] and taps on the suggestion tile labeled [tileText]. The query
    // must have multiple results, because the first suggestion tile is
    // covered by the search bar and cannot be tapped.
    Future<void> search(
      WidgetTester tester,
      String query,
      String tileText,
    ) async {
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, query);
      await tester.pumpAndSettle();
      await tester.tap(find.text(tileText).last);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      // The search page reveals the target unit with some asynchronous steps
      // (hidden units tile expansion, scroll and highlight)
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    }

    /// The height of the visible area in logical pixels
    double screenHeight(WidgetTester tester) =>
        tester.view.physicalSize.height / tester.view.devicePixelRatio;

    testWidgets('Search a unit of another property opens its page scrolled '
        'to the unit', (WidgetTester tester) async {
      await testInit(tester);

      await search(tester, 'Pascal', 'Gigapascal');

      expect(
        find.text('Pressure'),
        findsAtLeastNWidgets(1),
        reason: 'Expected the pressure page',
      );
      final rect = tester.getRect(
        find.byKey(const ValueKey('PRESSURE.gigaPascal')),
      );
      expect(
        rect.top >= 0 && rect.bottom <= screenHeight(tester),
        true,
        reason: 'The searched unit is not visible',
      );
    });

    testWidgets('Search a hidden unit expands the hidden units tile', (
      WidgetTester tester,
    ) async {
      await testInit(tester);

      // Enter edit mode to show the visibility handles
      await tester.tap(find.byKey(const ValueKey('editUnits')));
      await tester.pumpAndSettle();

      // The Nanometers unit is below the visible area: scroll down to it
      await tester.fling(
        find.byType(CustomScrollView).first,
        const Offset(0, -800),
        1000,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('unitVisibilityHandle-LENGTH.nanometers')),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Hidden units'),
        findsOneWidget,
        reason: 'Expected the hidden units tile',
      );

      await exitUnitsEditMode(tester);

      await search(tester, 'Meters', 'Nanometers');

      expect(
        find.text('Length'),
        findsAtLeastNWidgets(1),
        reason: 'Expected the length page',
      );
      // The hidden units tile must have been expanded
      final controller = ExpansibleController.of(
        tester.element(find.byKey(const ValueKey('unit-LENGTH.nanometers'))),
      );
      expect(controller.isExpanded, true, reason: 'Tile not expanded');
      final rect = tester.getRect(
        find.byKey(const ValueKey('LENGTH.nanometers')),
      );
      expect(
        rect.top >= 0 && rect.bottom <= screenHeight(tester),
        true,
        reason: 'The searched unit is not visible',
      );
    });
  });
}
