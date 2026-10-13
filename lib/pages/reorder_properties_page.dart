import 'package:collection/collection.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/pages/reorder_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReorderPropertiesPage extends ConsumerWidget {
  const ReorderPropertiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the order of the properties in the drawer
    final conversionsOrderDrawer = ref
        .watch(PropertiesOrderNotifier.provider)
        .value;
    final propertyUiMap = getPropertyUiMap(context);

    if (conversionsOrderDrawer == null) {
      return const SplashScreen();
    }
    final orderedProperties = conversionsOrderDrawer
        .map((e) => propertyUiMap[e]!)
        .toList();

    return ReorderPage(
      title: AppLocalizations.of(context)!.reorderProperties,
      itemsList: orderedProperties.map((e) => e.name).toList(),
      onSave: (List<int>? orderList) {
        if (orderList != null) {
          // Save the order
          ref.read(PropertiesOrderNotifier.provider.notifier).set(orderList);
          // Update the quick actions
          initializeQuickAction(
            conversionsOrderDrawer: ref
                .read(PropertiesOrderNotifier.provider)
                .value!,
            propertyUiMap: propertyUiMap,
            onActionSelection: (String shortcutType) {
              // The shortcut type is the toString() of a PROPERTYX (e.g.
              // 'PROPERTYX.length'): see initializeQuickAction.
              final selectedProperty = PROPERTYX.values.firstWhereOrNull(
                (e) => e.toString() == shortcutType,
              );
              if (selectedProperty != null) {
                context.go('/conversions/${selectedProperty.toKebabCase()}');
              }
            },
          );
        }
        context.pop();
      },
    );
  }
}
