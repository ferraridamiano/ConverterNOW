import 'package:converterpro/app_router.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/data/units_ordering.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isEverythingLoadedProvider)) {
      final conversionsOrderDrawer =
          ref.read(PropertiesOrderNotifier.provider).value!;
      initializeQuickAction(
        conversionsOrderDrawer: conversionsOrderDrawer,
        propertyUiMap: getPropertyUiMap(context),
        onActionSelection: (String shortcutType) {
          final int index = int.parse(shortcutType);
          context.go('/conversions/${propertiesOrdering[index].toKebabCase()}');
        },
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => GoRouter.of(context).go(
          '/conversions/${conversionsOrderDrawer[0].toKebabCase()}',
        ),
      );
    }

    return const SplashScreenWidget();
  }
}
