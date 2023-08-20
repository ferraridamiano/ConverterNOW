import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/navigator_utils.dart';
import 'package:converterpro/utils/property_unit_list.dart';
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
    key,
    required this.isDrawerFixed,
    required this.openCalculator,
    required this.openSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> headerDrawer = [];

    Color iconColor = getIconColor(Theme.of(context));

    final Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SvgPicture(
              AssetBytesLoader('assets/app_icons/logo.svg.vec'),
              width: 55,
            ),
            Text(
              'Converter NOW',
              // Fixed independently of the accessibility settings. Already as
              // large as possible
              textScaleFactor: 1,
              maxLines: 1,
              style: GoogleFonts.josefinSans(
                fontWeight: FontWeight.w300,
                textStyle: const TextStyle(fontSize: 31),
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
      headerDrawer.add(
        NavigationDrawerDestination(
          key: const ValueKey('drawerItem_search'),
          icon: Icon(Icons.search_outlined, color: iconColor),
          label: Text(AppLocalizations.of(context)!.search),
        ),
      );
      headerDrawer.add(
        NavigationDrawerDestination(
          key: const ValueKey('drawerItem_calculator'),
          icon: Icon(Icons.calculate_outlined, color: iconColor),
          label: Text(AppLocalizations.of(context)!.calculator),
        ),
      );
    }
    headerDrawer.add(NavigationDrawerDestination(
      key: const ValueKey('drawerItem_settings'),
      icon: Icon(Icons.settings_outlined, color: iconColor),
      label: Text(AppLocalizations.of(context)!.settings),
    ));
    headerDrawer.add(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Divider(),
      ),
    );

    List<int>? conversionsOrderDrawer;
    ref.watch(PropertiesOrderNotifier.provider).when(
          data: (data) => conversionsOrderDrawer = data,
          error: (_, stacktrace) => conversionsOrderDrawer = null,
          loading: () => conversionsOrderDrawer = null,
        );

    if (conversionsOrderDrawer == null) {
      return const SizedBox();
    }

    List<PropertyUi> propertyUiList = getPropertyUiList(context);
    List<Widget> conversionDrawer = List<Widget>.filled(
      propertyUiList.length,
      const SizedBox(),
    );

    for (int i = 0; i < propertyUiList.length; i++) {
      PropertyUi propertyUi = propertyUiList[i];
      conversionDrawer[conversionsOrderDrawer![i]] =
          NavigationDrawerDestination(
        key: ValueKey('drawerItem_${reversePageNumberListMap[i]}'),
        icon: SvgPicture(
          AssetBytesLoader(propertyUi.imagePath),
          width: 25,
          height: 25,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        label: Text(propertyUi.name),
      );
    }

    // How many NavigationDrawerDestination elements are there in the drawer
    int headerElements =
        headerDrawer.whereType<NavigationDrawerDestination>().toList().length;

    return NavigationDrawer(
      selectedIndex: pathToNavigationIndex(
          context, isDrawerFixed, conversionsOrderDrawer!),
      onDestinationSelected: (int selectedPage) {
        if (selectedPage >= headerElements) {
          context.go(
              '/conversions/${reversePageNumberListMap[conversionsOrderDrawer!.indexWhere((val) => val == selectedPage - headerElements)]}');
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
        ...conversionDrawer,
      ],
    );
  }
}

int pathToNavigationIndex(BuildContext context, bool isDrawerFixed,
    List<int> conversionsOrderDrawer) {
  final String location = GoRouterState.of(context).uri.toString();
  // 3 elements in the header
  if (isDrawerFixed) {
    if (location.startsWith('/conversions/')) {
      return conversionsOrderDrawer[computeSelectedConversionPage(context)!] +
          3;
    } else {
      return 2; // Settings
    }
  }
  // 1 element in the header
  else {
    if (location.startsWith('/conversions/')) {
      return conversionsOrderDrawer[computeSelectedConversionPage(context)!] +
          1;
    } else {
      return 0; // Settings
    }
  }
}
