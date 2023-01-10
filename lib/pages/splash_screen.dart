import 'dart:io';
import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:converterpro/main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int>? conversionsOrderDrawer =
        context.select<AppModel, List<int>?>(
            (appModel) => appModel.conversionsOrderDrawer);
    final bool isConversionsLoaded = context.select<Conversions, bool>(
        (conversions) => conversions.isConversionsLoaded);

    print('1. Is context null: ${rootNavigatorKey.currentContext == null}');

    if (isConversionsLoaded && conversionsOrderDrawer != null) {
      List<PropertyUi> propertyUiList = getPropertyUiList(context);
      final bool isMobileDevice =
          !kIsWeb && (Platform.isIOS || Platform.isAndroid);
      if (isMobileDevice) {
        initializeQuickAction(
          conversionsOrderDrawer: conversionsOrderDrawer,
          propertyUiList: propertyUiList,
          onActionSelection: (String shortcutType) {
            final int index = int.parse(shortcutType);
            context.go('/conversions/${reversePageNumberListMap[index]}');
          },
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('2. Is context null: ${rootNavigatorKey.currentContext == null}');
        GoRouter.of(rootNavigatorKey.currentContext!).go(
          '/conversions/${reversePageNumberListMap[conversionsOrderDrawer.indexWhere((val) => val == 0)]}',
        );
      });
    }

    return const SplashScreenWidget();
  }
}
