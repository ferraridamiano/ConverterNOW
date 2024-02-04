import 'package:converterpro/app_router.dart';
import 'package:converterpro/models/order.dart';
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
      List<PropertyUi> propertyUiList = getPropertyUiList(context);
      initializeQuickAction(
        conversionsOrderDrawer: conversionsOrderDrawer,
        propertyUiList: propertyUiList,
        onActionSelection: (String shortcutType) {
          final int index = int.parse(shortcutType);
          context.go('/conversions/${reversePageNumberListMap[index]}');
        },
      );

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => GoRouter.of(context).go(
          '/conversions/${reversePageNumberListMap[conversionsOrderDrawer.indexWhere((val) => val == 0)]}',
        ),
      );
    }

    updateNavBarColor(Theme.of(context).colorScheme);

    return const SplashScreenWidget();
  }
}
