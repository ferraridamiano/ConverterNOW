import 'package:converterpro/main.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/reorder_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ChoosePropertyPage extends ConsumerWidget {
  /// The index of the property the user tap. null means not yet selected.
  final int? selectedProperty;

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
    List<String> listUnitsNames = [];
    List<UnitData> selectedUnitDataList = [];
    // Read the order of the properties in the drawer
    List<int>? conversionsOrderDrawer =
        ref.watch(PropertiesOrderNotifier.provider).valueOrNull;

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }

    List<String> propertyNameList = getPropertyNameList(context);
    List<String> orderedDrawerList =
        List.filled(conversionsOrderDrawer.length, "");
    for (int i = 0; i < conversionsOrderDrawer.length; i++) {
      orderedDrawerList[conversionsOrderDrawer[i]] = propertyNameList[i];
    }

    final Map<dynamic, String> unitTranslationMap =
        getUnitTranslationMap(context);
    Widget? reorderPage;
    if (selectedProperty != null) {
      // if we remove the following check, if you enter the site directly to
      // '/conversions/:property' an error will occur
      if (!ref.watch(isEverythingLoadedProvider)) {
        return const SplashScreenWidget();
      }

      selectedUnitDataList = ref
          .read(ConversionsNotifier.provider.notifier)
          .getUnitDataListAtPage(conversionsOrderDrawer
              .indexWhere((index) => index == selectedProperty));
      listUnitsNames = List.generate(
        selectedUnitDataList.length,
        (index) => unitTranslationMap[selectedUnitDataList[index].unit.name]!,
      );
      reorderPage = ReorderPage(
        key: Key(listUnitsNames[0]),
        itemsList: listUnitsNames,
        onSave: (List<int>? orderList) {
          ref.read(UnitsOrderNotifier.provider.notifier).set(
                orderList,
                conversionsOrderDrawer
                    .indexWhere((index) => index == selectedProperty),
              );
          context.goNamed('settings');
        },
        title: AppLocalizations.of(context)!
            .reorderProperty(orderedDrawerList[selectedProperty!]),
      );
    }

    Color selectedListTileColor = Theme.of(context)
        .colorScheme
        .primaryContainer
        .withOpacity(
            Theme.of(context).brightness == Brightness.light ? 0.5 : 0.8);

    final Widget choosePropertyPage = CustomScrollView(
      slivers: <Widget>[
        SliverAppBar.large(
          title: Text(AppLocalizations.of(context)!.chooseProperty),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Stack(
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
                        '${orderedDrawerList[index]}-${(selectedProperty == index).toString()}'),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: selectedProperty == index
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
                          'chooseProperty-${reversePageNumberListMap[index]}'),
                      title: Text(
                        orderedDrawerList[index],
                        style: TextStyle(
                            fontSize: singlePageTextSize,
                            color: selectedProperty == index
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null),
                      ),
                      shape: const RoundedRectangleBorder(
                          borderRadius: borderRadius),
                      onTap: () {
                        if (selectedProperty == null ||
                            selectedProperty != index) {
                          context.go(
                            '/settings/reorder-units/${reversePageNumberListMap[index]}',
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
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
