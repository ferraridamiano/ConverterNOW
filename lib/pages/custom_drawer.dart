import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

const maxConversionUnits = 19;

class CustomDrawer extends StatelessWidget {
  final bool isDrawerFixed;
  final void Function() openCalculator;
  final void Function() openSearch;

  const CustomDrawer({
    Key? key,
    required this.openCalculator,
    required this.openSearch,
    required this.isDrawerFixed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List<Widget> headerDrawer = [];
    List<Widget> conversionDrawer = List<Widget>.filled(maxConversionUnits, const SizedBox());

    int currentPage = context.select<AppModel, int>((appModel) => appModel.currentPage);
    MAIN_SCREEN currentScreen = context.select<AppModel, MAIN_SCREEN>((appModel) => appModel.currentScreen);

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
            context.read<AppModel>()
              ..changeToPage(context.read<AppModel>().conversionsOrderDrawer.indexWhere((val) => val == 0))
              ..currentScreen = MAIN_SCREEN.conversion;
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
        onTap: () => openSearch(),
        selected: false,
      ),
    );
    if (isDrawerFixed) {
      headerDrawer.add(
        DrawerTile(
          leading: const Icon(Icons.calculate_outlined),
          title: Text(AppLocalizations.of(context)!.calculator),
          onTap: () => openCalculator(),
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
            context.read<AppModel>().currentScreen = MAIN_SCREEN.settings;
          },
          selected: currentScreen == MAIN_SCREEN.settings ||
              currentScreen == MAIN_SCREEN.reorderProperties ||
              currentScreen == MAIN_SCREEN.reorderUnits,
        ),
      )
      ..add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black38),
        ),
      );

    List<int> conversionsOrderDrawer = context.watch<AppModel>().conversionsOrderDrawer;

    //*the following lines are more optimized then the previous one but don't know
    //*why it doesn't work :(
    /*List<int> conversionsOrderDrawer = context.select<AppModel, List<int>>(
      (appModel) => appModel.conversionsOrderDrawer
    );*/

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
          context.read<AppModel>()
            ..changeToPage(i)
            ..currentScreen = MAIN_SCREEN.conversion;
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        },
        selected: currentScreen == MAIN_SCREEN.conversion && currentPage == i,
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
