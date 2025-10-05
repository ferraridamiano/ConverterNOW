import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class InitialPage extends ConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Row(
              spacing: 16,
              children: [
                const SvgPicture(
                  AssetBytesLoader('assets/app_icons_opti/logo.svg.vec'),
                  width: 36,
                  height: 36,
                ),
                Text(AppLocalizations.of(context)!.appName),
              ],
            ),
          ),
          SliverGrid.extent(
            maxCrossAxisExtent: 180,
            children: getPropertyGridTiles(
              (PROPERTYX e) {
                HapticFeedback.selectionClick();
                context.go('/conversions/${e.toKebabCase()}');
              },
              context,
              ref.read(PropertiesOrderNotifier.provider).value!,
            ),
          )
        ],
      ),
    );
  }
}
