import 'package:converterpro/models/order.dart';
import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/pages/reorder_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReorderPropertiesPage extends ConsumerWidget {
  const ReorderPropertiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the order of the properties in the drawer
    final conversionsOrderDrawer =
        ref.watch(PropertiesOrderNotifier.provider).value;
    final propertyUiMap = getPropertyUiMap(context);

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }
    final orderedProperties =
        conversionsOrderDrawer.map((e) => propertyUiMap[e]!).toList();

    return ReorderPage(
      title: AppLocalizations.of(context)!.reorderProperties,
      itemsList: orderedProperties.map((e) => e.name).toList(),
      onSave: (List<int>? orderList) {
        if (orderList != null) {
          // Save the order
          ref.read(PropertiesOrderNotifier.provider.notifier).set(orderList);
          // Update the quick actions
          initializeQuickAction(
            conversionsOrderDrawer:
                ref.read(PropertiesOrderNotifier.provider).value!,
            propertyUiMap: propertyUiMap,
            onActionSelection: (String shortcutType) {
              final int index = int.parse(shortcutType);
              context.go(
                  '/conversions/${defaultPropertiesOrder[index].toKebabCase()}');
            },
          );
        }
        context.pop();
      },
    );
  }
}
