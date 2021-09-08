import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:converterpro/utils/UtilsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePropertyPage extends StatefulWidget {
  const ChoosePropertyPage(this.orderedDrawerList, {Key? key}) : super(key: key);

  final List<String> orderedDrawerList;

  @override
  _ChoosePropertyPageState createState() => _ChoosePropertyPageState();
}

class _ChoosePropertyPageState extends State<ChoosePropertyPage> {
  int selectedProperty = 0;
  static const BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    List<int> conversionsOrderDrawer = context.read<AppModel>().conversionsOrderDrawer;
    final Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    List<UnitData> selectedUnitDataList = context
        .read<Conversions>()
        .getUnitDataListAtPage(conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
    List<String> listUnitsNames = List.generate(
        selectedUnitDataList.length, (index) => unitTranslationMap[selectedUnitDataList[index].unit.name]!);

    final double displayWidth = MediaQuery.of(context).size.width;
    final double xPadding = responsivePadding(displayWidth);

    return Expanded(
      child: LayoutBuilder(builder: (BuildContext context, _) {
        if (isDrawerFixed(displayWidth)) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    BigTitle(
                      text: AppLocalizations.of(context)!.chooseProperty,
                      sidePadding: xPadding,
                      center: true,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.orderedDrawerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  final offsetAnimation =
                                      Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
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
                                    child: ListTile(),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Center(
                                  child: Text(
                                    widget.orderedDrawerList[index],
                                    style: TextStyle(
                                        fontSize: SINGLE_PAGE_TEXT_SIZE,
                                        color: selectedProperty == index ? Colors.white : null),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                                onTap: () {
                                  if (selectedProperty != index) {
                                    setState(() {
                                      selectedProperty = index;
                                    });
                                  }
                                },
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
                  SizedBox(height: 95),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 2,
                    child: VerticalDivider(
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final offsetAnimation =
                          Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    child: 
                      ReorderPage(
                      key: Key(listUnitsNames[0]),
                      itemsList: listUnitsNames,
                      onSave: (List<int>? orderList) {
                        context.read<Conversions>().saveOrderUnits(
                            orderList, conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
                        context.read<AppModel>().currentScreen = MAIN_SCREEN.SETTINGS;
                      },
                      header: BigTitle(
                        text: AppLocalizations.of(context)!.reorderProperty(widget.orderedDrawerList[selectedProperty]),
                        sidePadding: xPadding,
                        center: true,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text(widget.orderedDrawerList[index]),
              ),
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              onTap: () {
                if (selectedProperty != index) {
                  setState(() {
                    selectedProperty = index;
                  });
                }
              },
            );
          },
          itemCount: widget.orderedDrawerList.length,
        );
      }),
    );
  }
}
