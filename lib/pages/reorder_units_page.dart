import 'package:converterpro/app_router.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/pages/choose_property_page.dart';
import 'package:converterpro/utils/reorder_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReorderUnitsPage extends ConsumerWidget {
  /// The index of the property the user tap. null means not yet selected.
  final PROPERTYX? selectedProperty;

  /// If `isDrawerFixed=false` then this variable is used to transition from the
  /// "Choose property page" to the "Reorder units" page
  final bool isPropertySelected;

  const ReorderUnitsPage({
    this.selectedProperty,
    this.isPropertySelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the order of the properties in the drawer
    final conversionsOrderDrawer =
        ref.watch(PropertiesOrderNotifier.provider).valueOrNull;

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }

    final propertyUiMap = getPropertyUiMap(context);

    Widget? reorderPage;
    if (selectedProperty != null) {
      final unitUiMap = getUnitUiMap(context);
      final conversionOrderUnits =
          ref.watch(UnitsOrderNotifier.provider).value![selectedProperty]!;
      // if we remove the following check, if you enter the site directly to
      // '/conversions/:property' an error will occur
      if (!ref.watch(isEverythingLoadedProvider)) {
        return const SplashScreenWidget();
      }
      reorderPage = ReorderPage(
        key: Key(selectedProperty.toString()),
        itemsList: conversionOrderUnits
            .map((e) => unitUiMap[selectedProperty]![e]!)
            .toList(),
        onSave: (List<int>? orderList) {
          ref.read(UnitsOrderNotifier.provider.notifier).set(
                orderList,
                selectedProperty!,
              );
          context.goNamed('settings');
        },
        title: AppLocalizations.of(context)!
            .reorderProperty(propertyUiMap[selectedProperty]!.name),
      );
    }

    final choosePropertyPage = ChoosePropertyPage(
      selectedProperty: selectedProperty,
      onSelectedProperty: (property) => context.go(
        '/settings/reorder-units/${property.toKebabCase()}',
      ),
    );

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // Enough space for two sided pages
      if (constraints.maxWidth > twoSidedReorderScreen) {
        return Row(
          children: [
            Expanded(child: choosePropertyPage),
            if (selectedProperty != null)
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final offsetAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0))
                        .animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: reorderPage,
                ),
              ),
          ],
        );
      }
      // One page at a time
      if (!isPropertySelected) {
        return choosePropertyPage;
      }
      return reorderPage!;
    });
  }
}
