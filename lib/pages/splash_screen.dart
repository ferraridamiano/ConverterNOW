import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int>? conversionsOrderDrawer =
        context.select<AppModel, List<int>?>((appModel) => appModel.conversionsOrderDrawer);
    final bool isConversionsLoaded = context.select<Conversions, bool>((conversions) => conversions.isConversionsLoaded);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (isConversionsLoaded && conversionsOrderDrawer != null) {
        context.go('/conversions/' + reversePageNumberListMap[conversionsOrderDrawer.indexWhere((val) => val == 0)]);
      }
    });

    return const SplashScreenWidget();
  }
}
