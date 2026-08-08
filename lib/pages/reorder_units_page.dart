import 'package:converterpro/app_router.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/pages/reorder_page.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReorderUnitsPage extends ConsumerWidget {
  /// The property whose units the user is reordering
  final PROPERTYX property;

  const ReorderUnitsPage(this.property, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if we remove the following check, if you enter the site directly to
    // '/reorder-units/:property' an error will occur
    if (!ref.watch(isEverythingLoadedProvider)) {
      return const SplashScreenWidget();
    }

    final unitUiMap = getUnitUiMap(context);
    final propertyUiMap = getPropertyUiMap(context);
    final conversionOrderUnits = ref
        .watch(UnitsOrderNotifier.provider)
        .value![property]!;

    return ReorderPage(
      key: Key(property.toString()),
      itemsList: conversionOrderUnits
          .map((e) => unitUiMap[property]![e]!)
          .toList(),
      onSave: (List<int>? orderList) {
        ref
            .read(UnitsOrderNotifier.provider.notifier)
            .set(orderList, property);
        context.go('/conversions/${property.toKebabCase()}');
      },
      title: AppLocalizations.of(
        context,
      )!.reorderProperty(propertyUiMap[property]!.name),
    );
  }
}
