import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/utils/navigator_utils.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translations/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:vector_graphics/vector_graphics.dart';

const maxConversionUnits = 19;

class CustomDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    AppPage selectedSection = computeSelectedSection(context);
    int? selectedIndex = computeSelectedConversionPage(context);

    List<Widget> headerDrawer = [];
    List<Widget> conversionDrawer = List<Widget>.filled(
      maxConversionUnits,
      const SizedBox(),
    );

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
              // Fixed indipendently of the accessibility settings. Already as
              // large as possibile
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
    if (isDrawerFixed) {
      headerDrawer.add(
        InkWell(
          onTap: () {
            context.go('/');
            if (!isDrawerFixed) {
              Navigator.of(context).pop();
            }
          },
          child: title,
        ),
      );
    } else {
      headerDrawer.add(title);
    }

    if (isDrawerFixed) {
      headerDrawer.add(
        DrawerTile(
          key: const ValueKey('drawerItem_search'),
          leading: Icon(Icons.search_outlined, color: iconColor),
          title: Text(AppLocalizations.of(context)!.search),
          onTap: openSearch,
        ),
      );
      headerDrawer.add(
        DrawerTile(
          key: const ValueKey('drawerItem_calculator'),
          leading: Icon(Icons.calculate_outlined, color: iconColor),
          title: Text(AppLocalizations.of(context)!.calculator),
          onTap: openCalculator,
        ),
      );
    }
    headerDrawer
      ..add(DrawerTile(
        key: const ValueKey('drawerItem_settings'),
        leading: Icon(Icons.settings_outlined, color: iconColor),
        title: Text(AppLocalizations.of(context)!.settings),
        onTap: () {
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
          context.goNamed('settings');
        },
        selected: selectedSection == AppPage.settings ||
            selectedSection == AppPage.reorder,
      ))
      ..add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(),
        ),
      );

    List<int> conversionsOrderDrawer = context.select<AppModel, List<int>>(
      (appModel) => appModel.conversionsOrderDrawer!,
    );

    List<PropertyUi> propertyUiList = getPropertyUiList(context);

    for (int i = 0; i < propertyUiList.length; i++) {
      PropertyUi propertyUi = propertyUiList[i];
      conversionDrawer[conversionsOrderDrawer[i]] = DrawerTile(
        key: ValueKey('drawerItem_${reversePageNumberListMap[i]}'),
        leading: SvgPicture(
          AssetBytesLoader(propertyUi.imagePath),
          width: 25,
          height: 25,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        title: Text(propertyUi.name),
        onTap: () {
          context.go('/conversions/${reversePageNumberListMap[i]}');
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        },
        selected: selectedSection == AppPage.conversions && selectedIndex == i,
      );
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          controller: ScrollController(),
          padding: EdgeInsets.zero,
          children: [
            ...headerDrawer,
            ...conversionDrawer,
          ],
        ),
      ),
    );
  }
}
