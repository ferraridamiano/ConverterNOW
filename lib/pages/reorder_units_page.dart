import 'package:converterpro/app_router.dart';
import 'package:converterpro/models/order.dart';
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

class ChoosePropertyPage extends ConsumerWidget {
  /// The index of the property the user tap. null means not yet selected.
  final PROPERTYX? selectedProperty;

  /// If `isDrawerFixed=false` then this variable is used to transition from the
  /// "Choose property page" to the "Reorder units" page
  final bool isPropertySelected;

  const ChoosePropertyPage({
    this.selectedProperty,
    this.isPropertySelected = false,
    super.key,
  });

  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the order of the properties in the drawer
    final conversionsOrderDrawer =
        ref.watch(PropertiesOrderNotifier.provider).valueOrNull;

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }

    final propertyUiMap = getPropertyUiMap(context);
    List<String> orderedDrawerList =
        conversionsOrderDrawer.map((e) => propertyUiMap[e]!.name).toList();

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

    Color selectedListTileColor = Theme.of(context)
        .colorScheme
        .primaryContainer
        .withValues(
          alpha: Theme.of(context).brightness == Brightness.light ? 0.5 : 0.8,
        );

    final Widget choosePropertyPage = CustomScrollView(
      slivers: <Widget>[
        SliverAppBar.large(
          title: Text(AppLocalizations.of(context)!.chooseProperty),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final isSelectedProperty =
                  conversionsOrderDrawer[index] == selectedProperty;
              return Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: const Offset(0.0, 0.0),
                      ).animate(animation);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    child: Padding(
                      key: Key(
                          '${orderedDrawerList[index]}-$isSelectedProperty'),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: isSelectedProperty
                            ? BoxDecoration(
                                color: selectedListTileColor,
                                borderRadius: borderRadius,
                              )
                            : null,
                        child: const ListTile(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: ListTile(
                        key: ValueKey(
                            'chooseProperty-${conversionsOrderDrawer[index]}'),
                        title: Text(
                          orderedDrawerList[index],
                          style: TextStyle(
                            fontSize: singlePageTextSize,
                            color: isSelectedProperty
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius: borderRadius),
                        onTap: () {
                          context.go(
                            '/settings/reorder-units/${conversionsOrderDrawer[index].toKebabCase()}',
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            childCount: orderedDrawerList.length,
          ),
        )
      ],
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
