import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/utils/reorder_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ChoosePropertyPage extends StatelessWidget {
  /// The index of the property the user tap. null means not yet selected.
  final int? selectedProperty;

  /// If `isDrawerFixed=false` then this variable is used to transition from the "Choose property page" to the "Reorder
  /// units" page
  final bool isPropertySelected;

  const ChoosePropertyPage({this.selectedProperty, this.isPropertySelected = false, Key? key}) : super(key: key);

  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    List<String> listUnitsNames = [];
    List<UnitData> selectedUnitDataList = [];
    // Read the order of the properties in the drawer
    List<int>? conversionsOrderDrawer = context.read<AppModel>().conversionsOrderDrawer;

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }

    List<String> propertyNameList = getPropertyNameList(context);
    List<String> orderedDrawerList = List.filled(conversionsOrderDrawer.length, "");
    for (int i = 0; i < conversionsOrderDrawer.length; i++) {
      orderedDrawerList[conversionsOrderDrawer[i]] = propertyNameList[i];
    }

    final Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    if (selectedProperty != null) {
      final bool isConversionsLoaded =
          context.select<Conversions, bool>((conversions) => conversions.isConversionsLoaded);
      // if we remove the following check, if you enter the site directly to
      // '/conversions/:property' an error will occur
      if (!isConversionsLoaded) {
        return const SplashScreenWidget();
      }
      
      selectedUnitDataList = context
          .read<Conversions>()
          .getUnitDataListAtPage(conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
      listUnitsNames = List.generate(
          selectedUnitDataList.length, (index) => unitTranslationMap[selectedUnitDataList[index].unit.name]!);
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > twoSidedReorderScreen) {
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  BigTitle(
                    text: AppLocalizations.of(context)!.chooseProperty,
                    center: true,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: orderedDrawerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                final offsetAnimation =
                                    Tween<Offset>(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
                                        .animate(animation);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              child: Padding(
                                key: Key(orderedDrawerList[index] + '-' + (selectedProperty == index).toString()),
                                padding: const EdgeInsets.symmetric(horizontal: 50),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        selectedProperty == index ? Theme.of(context).primaryColor : Colors.transparent,
                                    borderRadius: borderRadius,
                                  ),
                                  child: const ListTile(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    orderedDrawerList[index],
                                    style: TextStyle(
                                        fontSize: singlePageTextSize,
                                        color: selectedProperty == index ? Colors.white : null),
                                  ),
                                ),
                                shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                                onTap: () {
                                  if (selectedProperty != index) {
                                    context.go('/settings/reorder-units/${reversePageNumberListMap[index]}');
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (selectedProperty != null)
              Column(
                children: [
                  const SizedBox(height: 95),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 2,
                    child: VerticalDivider(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black38,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            if (selectedProperty != null)
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final offsetAnimation =
                        Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: ReorderPage(
                    key: Key(listUnitsNames[0]),
                    itemsList: listUnitsNames,
                    onSave: (List<int>? orderList) {
                      context.read<Conversions>().saveOrderUnits(
                          orderList, conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
                      context.goNamed('settings');
                    },
                    header: BigTitle(
                      text: AppLocalizations.of(context)!.reorderProperty(orderedDrawerList[selectedProperty!]),
                      center: true,
                    ),
                  ),
                ),
              )
          ],
        );
      }
      // if the drawer is not fixed. We check if we are in the first "Choose property page"
      if (!isPropertySelected) {
        return Column(
          children: [
            BigTitle(
              text: AppLocalizations.of(context)!.chooseProperty,
              center: true,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Center(
                      child: Text(
                        orderedDrawerList[index],
                        style: const TextStyle(
                          fontSize: singlePageTextSize,
                        ),
                      ),
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                    onTap: () {
                      if (selectedProperty != index) {
                        context.go('/settings/reorder-units/${reversePageNumberListMap[index]}');
                      }
                    },
                  );
                },
                itemCount: orderedDrawerList.length,
              ),
            ),
          ],
        );
      }
      return ReorderPage(
        itemsList: listUnitsNames,
        onSave: (List<int>? orderList) {
          context
              .read<Conversions>()
              .saveOrderUnits(orderList, conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
          context.goNamed('settings');
        },
        header: BigTitle(
          text: AppLocalizations.of(context)!.reorderProperty(orderedDrawerList[selectedProperty!]),
          center: true,
        ),
      );
    });
  }
}
