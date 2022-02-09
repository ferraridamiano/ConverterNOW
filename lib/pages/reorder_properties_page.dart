import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/utils/reorder_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReorderPropertiesPage extends StatelessWidget {
  const ReorderPropertiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return ReorderPage(
      header: BigTitle(
        text: AppLocalizations.of(context)!.reorderProperties,
        center: true,
      ),
      itemsList: orderedDrawerList,
      onSave: (List<int>? orderList) {
        if (orderList != null) {
          // Save the order
          context.read<AppModel>().saveOrderDrawer(orderList);
          // Update the quick actions
          List<PropertyUi> propertyUiList = getPropertyUiList(context);
          initializeQuickAction(
            conversionsOrderDrawer: orderList,
            propertyUiList: propertyUiList,
            onActionSelection: (String shortcutType) {
              final int index = int.parse(shortcutType);
              context.go('/conversions/' + reversePageNumberListMap[index]);
            },
          );
        }
        context.goNamed('settings');
      },
    );
  }
}
