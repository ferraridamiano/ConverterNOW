import 'package:converterpro/app_router.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/pages/choose_property_page.dart';
import 'package:converterpro/pages/select_units_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HideUnitsPage extends ConsumerWidget {
  /// The index of the property the user tap. null means not yet selected.
  final PROPERTYX? selectedProperty;

  /// If `isDrawerFixed=false` then this variable is used to transition from the
  /// "Choose property page" to the "Reorder units" page
  final bool isPropertySelected;

  const HideUnitsPage({
    super.key,
    this.selectedProperty,
    this.isPropertySelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the order of the properties in the drawer
    final conversionsOrderDrawer =
        ref.watch(PropertiesOrderNotifier.provider).valueOrNull;

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }

    Widget? hideUnitsPage;
    if (selectedProperty != null) {
      // if we remove the following check, if you enter the site directly to
      // '/conversions/:property' an error will occur
      if (!ref.watch(isEverythingLoadedProvider)) {
        return const SplashScreenWidget();
      }
      hideUnitsPage = SelectUnitsPage(selectedProperty: selectedProperty!);
    }

    final choosePropertyPage = ChoosePropertyPage(
      selectedProperty: selectedProperty,
      onSelectedProperty: (property) => context.go(
        '/settings/hide-units/${property.toKebabCase()}',
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
                  child: hideUnitsPage,
                ),
              ),
          ],
        );
      }
      // One page at a time
      if (!isPropertySelected) {
        return choosePropertyPage;
      }
      return hideUnitsPage!;
    });
  }
}
