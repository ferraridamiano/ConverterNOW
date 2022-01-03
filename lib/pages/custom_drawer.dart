import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/pages/search_page.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

const maxConversionUnits = 19;

class CustomDrawer extends StatelessWidget {

  final bool isDrawerFixed;
  final ScaffoldSection selectedSection;
  final int selectedIndex;
  final void Function() openCalculator;

  const CustomDrawer({
    key,
    required this.isDrawerFixed,
    required this.selectedSection,
    required this.selectedIndex,
    required this.openCalculator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> headerDrawer = [];
    List<Widget> conversionDrawer = List<Widget>.filled(maxConversionUnits, const SizedBox());

    final Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'resources/images/logo.png',
              width: 55,
              filterQuality: FilterQuality.medium,
            ),
            const SizedBox(width: 10),
            Text(
              'Converter NOW',
              textScaleFactor: 1, // fixed indipendently of the accessibility settings. Already as large as possibile
              style: GoogleFonts.josefinSans(
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

    headerDrawer.add(
      DrawerTile(
        leading: const Icon(Icons.search_outlined),
        title: Text(AppLocalizations.of(context)!.search),
        onTap: () async {
          final orderList = context.read<AppModel>().conversionsOrderDrawer;
          final int? newPage = await showSearch(
            context: context,
            delegate: CustomSearchDelegate(orderList!),
          );
          if (newPage != null) {
            AppModel appModel = context.read<AppModel>();
            if (appModel.currentPage != newPage) appModel.changeToPage(newPage);
          }
        },
        selected: false,
      ),
    );
    if (isDrawerFixed) {
      headerDrawer.add(
        DrawerTile(
          leading: const Icon(Icons.calculate_outlined),
          title: Text(AppLocalizations.of(context)!.calculator),
          onTap: openCalculator,
          selected: false,
        ),
      );
    }
    headerDrawer
      ..add(
        DrawerTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              if (!isDrawerFixed) {
                Navigator.of(context).pop();
              }
              context.goNamed('settings');
            },
            selected: selectedSection ==
                ScaffoldSection
                    .settings /*||
              currentScreen == MAIN_SCREEN.reorderProperties ||
              currentScreen == MAIN_SCREEN.reorderUnits,*/
            ),
      )
      ..add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black38),
        ),
      );

    List<int> conversionsOrderDrawer =
        List.generate(maxConversionUnits, (index) => index); //context.watch<AppModel>().conversionsOrderDrawer;

    List<PropertyUi> propertyUiList = getPropertyUiList(context);

    for (int i = 0; i < propertyUiList.length; i++) {
      PropertyUi propertyUi = propertyUiList[i];
      conversionDrawer[conversionsOrderDrawer[i]] = DrawerTile(
        leading: Image.asset(
          propertyUi.imagePath,
          width: 30,
          height: 30,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black38,
          filterQuality: FilterQuality.medium,
        ),
        title: Text(propertyUi.name),
        onTap: () {
          context.go('/conversions/${reversePageNumberListMap[i]}');

          /*context.read<AppModel>()
            ..changeToPage(i)
            ..currentScreen = MAIN_SCREEN.conversion;*/
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        },
        selected: selectedSection == ScaffoldSection.conversions && selectedIndex == i,
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
