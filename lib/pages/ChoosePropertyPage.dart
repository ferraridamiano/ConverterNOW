import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChoosePropertyPage extends StatefulWidget {
  const ChoosePropertyPage(this.orderedDrawerList, {Key? key}) : super(key: key);

  final List<String> orderedDrawerList;

  @override
  _ChoosePropertyPageState createState() => _ChoosePropertyPageState();
}

class _ChoosePropertyPageState extends State<ChoosePropertyPage> {
  int selectedProperty = 0;
  late List<UnitData> selectedUnitDataList;
  late List<String> listUnitsNames;

  @override
  Widget build(BuildContext context) {

    //
    List<int> conversionsOrderDrawer = context.read<AppModel>().conversionsOrderDrawer;
    
    //

    final Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    List<UnitData> selectedUnitDataList = context.read<Conversions>().getUnitDataListAtPage(conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
    List<String> listUnitsNames = List.generate(
        selectedUnitDataList.length, (index) => unitTranslationMap[selectedUnitDataList[index].unit.name]!);

    final double displayWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: selectedProperty == index ? Theme.of(context).accentColor : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(
                    title: Text(widget.orderedDrawerList[index]),
                    onTap: () {
                      if (selectedProperty != index) {
                        setState(() {
                          selectedProperty = index;
                        });
                      }
                    },
                  ),
                );
              },
              itemCount: widget.orderedDrawerList.length,
            ),
          ),
          if (isDrawerFixed(displayWidth))
            ReorderPage(
              itemsList: listUnitsNames,
              onSave: (List<int>? orderList) {
                context.read<Conversions>().saveOrderUnits(orderList, conversionsOrderDrawer.indexWhere((index) => index == selectedProperty));
                context.read<AppModel>().currentScreen = MAIN_SCREEN.SETTINGS;
              },
            )
        ],
      ),
    );
  }
}
