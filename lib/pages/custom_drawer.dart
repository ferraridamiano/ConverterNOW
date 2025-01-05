import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/navigator_utils.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CustomDrawer extends ConsumerWidget {
  final bool isDrawerFixed;
  final void Function() openCalculator;
  final void Function() openSearch;

  const CustomDrawer({
    required this.isDrawerFixed,
    required this.openCalculator,
    required this.openSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    List<Widget> headerDrawer = [];

    Color iconColor = getIconColor(Theme.of(context));

    final Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SvgPicture(
              AssetBytesLoader('assets/app_icons/logo.svg'),
              width: 50,
            ),
            Text(
              'Converter NOW',
              // Fixed independently of the accessibility settings. Already as
              // large as possible
              textScaler: TextScaler.noScaling,
              maxLines: 1,
              style: GoogleFonts.josefinSans(
                fontWeight: FontWeight.w300,
                textStyle: const TextStyle(fontSize: 29),
              ),
            ),
          ],
        ),
      ),
    );
    headerDrawer.add(isDrawerFixed
        ? InkWell(
            onTap: () => context.go('/'),
            child: title,
          )
        : title);

    if (isDrawerFixed) {
      final keyDecoration = BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(6),
      );
      const keyPadding = EdgeInsets.symmetric(horizontal: 4);
      headerDrawer.add(
        NavigationDrawerDestination(
          key: const ValueKey('drawerItem_search'),
          icon: Icon(Icons.search_outlined, color: iconColor),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(l10n.search),
              const SizedBox(width: 16),
              Container(
                decoration: keyDecoration,
                child: const Padding(
                  padding: keyPadding,
                  child: Text('Ctrl'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text('+'),
              ),
              Container(
                decoration: keyDecoration,
                child: const Padding(
                  padding: keyPadding,
                  child: Text('K'),
                ),
              ),
            ],
          ),
        ),
      );
      headerDrawer.add(
        NavigationDrawerDestination(
          key: const ValueKey('drawerItem_calculator'),
          icon: Icon(Icons.calculate_outlined, color: iconColor),
          label: Text(l10n.calculator),
        ),
      );
    }
    headerDrawer.add(NavigationDrawerDestination(
      key: const ValueKey('drawerItem_settings'),
      icon: Icon(Icons.settings_outlined, color: iconColor),
      label: Text(l10n.settings),
    ));
    headerDrawer.add(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Divider(),
      ),
    );

    List<PROPERTYX>? propertiesOrdering =
        ref.watch(PropertiesOrderNotifier.provider).valueOrNull;

    if (propertiesOrdering == null) {
      return const SizedBox();
    }

    final propertyUiMap = getPropertyUiMap(context);
    final propertiesDrawer = propertiesOrdering.map((e) {
      final propertyUi = propertyUiMap[e]!;
      return NavigationDrawerDestination(
        key: ValueKey('drawerItem_$e'),
        icon: SvgPicture(
          AssetBytesLoader(propertyUi.imagePath),
          width: 25,
          height: 25,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        label: Text(propertyUi.name),
      );
    });

    // How many NavigationDrawerDestination elements are there in the drawer
    int headerElements =
        headerDrawer.whereType<NavigationDrawerDestination>().toList().length;

    return NavigationDrawer(
      selectedIndex: pathToNavigationIndex(
        context,
        isDrawerFixed,
        propertiesOrdering.inverse(),
      ),
      onDestinationSelected: (int selectedPage) {
        if (selectedPage >= headerElements) {
          context.go(
              '/conversions/${propertiesOrdering[selectedPage - headerElements].toKebabCase()}');
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        } else if (headerElements == 3) {
          switch (selectedPage) {
            case 0:
              openSearch();
            case 1:
              openCalculator();
            case 2:
              if (!isDrawerFixed) {
                Navigator.of(context).pop();
              }
              context.goNamed('settings');
          }
        } else if (headerElements == 1) {
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
          context.goNamed('settings');
        }
      },
      children: <Widget>[
        ...headerDrawer,
        ...propertiesDrawer,
      ],
    );
  }
}

int pathToNavigationIndex(BuildContext context, bool isDrawerFixed,
    Map<PROPERTYX, int> inversePropertiesOrdering) {
  final String location = GoRouterState.of(context).uri.toString();

  // 3 elements in the header
  if (isDrawerFixed) {
    if (location.startsWith('/conversions/')) {
      return computeSelectedConversionPage(
              context, inversePropertiesOrdering)! +
          3;
    } else {
      return 2; // Settings
    }
  }
  // 1 element in the header
  else {
    if (location.startsWith('/conversions/')) {
      return computeSelectedConversionPage(
              context, inversePropertiesOrdering)! +
          1;
    } else {
      return 0; // Settings
    }
  }
}
