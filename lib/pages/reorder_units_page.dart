import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/pages/choose_property_page.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ReorderUnitsPage extends StatelessWidget {
  const ReorderUnitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Read the order of the properties in the drawer
    List<int> conversionsOrderDrawer = context.watch<AppModel>().conversionsOrderDrawer;
    List<String> propertyNameList = getPropertyNameList(context);
    List<String> orderedDrawerList = List.filled(conversionsOrderDrawer.length, "");
    for (int i = 0; i < conversionsOrderDrawer.length; i++) {
      orderedDrawerList[conversionsOrderDrawer[i]] = propertyNameList[i];
    }

    return WillPopScope(
      onWillPop: () async {
        context.goNamed('settings');
        return false;
      },
      child: ChoosePropertyPage(
        orderedDrawerList: orderedDrawerList,
      ),
    );
  }
}
