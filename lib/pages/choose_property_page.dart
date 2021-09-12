import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/pages/reorder_page.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePropertyPage extends StatefulWidget {
  const ChoosePropertyPage({
    required this.orderedDrawerList,
    Key? key,
  }) : super(key: key);

  final List<String> orderedDrawerList;

  @override
  _ChoosePropertyPageState createState() => _ChoosePropertyPageState();
}

class _ChoosePropertyPageState extends State<ChoosePropertyPage> {
  int selectedProperty = 0;

  /// If `isDrawerFixed=false` then this variable is used to transition from the "Choose property page" to the "Reorder
  /// units" page
  bool isPropertySelected = false;
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    List<int> conversionsOrderDrawer = context.read<AppModel>().conversionsOrderDrawer;
    final Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    List<UnitData> selectedUnitDataList = context
        .read<Conversions>()
        .getUnitDataListAtPage(conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
    List<String> listUnitsNames = List.generate(
        selectedUnitDataList.length, (index) => unitTranslationMap[selectedUnitDataList[index].unit.name]!);

    return Expanded(
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
                        itemCount: widget.orderedDrawerList.length,
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
                                  key: Key(
                                      widget.orderedDrawerList[index] + '-' + (selectedProperty == index).toString()),
                                  padding: const EdgeInsets.symmetric(horizontal: 50),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedProperty == index
                                          ? Theme.of(context).primaryColor
                                          : Colors.transparent,
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
                                      widget.orderedDrawerList[index],
                                      style: TextStyle(
                                          fontSize: singlePageTextSize,
                                          color: selectedProperty == index ? Colors.white : null),
                                    ),
                                  ),
                                  shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                                  onTap: () {
                                    if (selectedProperty != index) {
                                      setState(() {
                                        selectedProperty = index;
                                      });
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
                      context.read<AppModel>().currentScreen = MAIN_SCREEN.settings;
                    },
                    header: BigTitle(
                      text: AppLocalizations.of(context)!.reorderProperty(widget.orderedDrawerList[selectedProperty]),
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
                          widget.orderedDrawerList[index],
                          style: const TextStyle(
                            fontSize: singlePageTextSize,
                          ),
                        ),
                      ),
                      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                      onTap: () {
                        if (selectedProperty != index) {
                          setState(() {
                            selectedProperty = index;
                            isPropertySelected = true;
                          });
                        }
                      },
                    );
                  },
                  itemCount: widget.orderedDrawerList.length,
                ),
              ),
            ],
          );
        }
        return WillPopScope(
          onWillPop: () async {
            setState(() {
              isPropertySelected = false;
            });
            return false;
          },
          child: ReorderPage(
            itemsList: listUnitsNames,
            onSave: (List<int>? orderList) {
              context
                  .read<Conversions>()
                  .saveOrderUnits(orderList, conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
              context.read<AppModel>().currentScreen = MAIN_SCREEN.settings;
            },
            header: BigTitle(
              text: AppLocalizations.of(context)!.reorderProperty(widget.orderedDrawerList[selectedProperty]),
              center: true,
            ),
          ),
        );
      }),
    );
  }
}
