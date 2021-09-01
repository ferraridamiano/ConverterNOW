import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:converterpro/utils/UtilsWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

const MAX_CONVERSION_UNITS = 19;

class CustomDrawer extends StatefulWidget {
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
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    late List<Widget> headerDrawer = [];
    List<Widget> conversionDrawer = List<Widget>.filled(MAX_CONVERSION_UNITS, SizedBox());

    int currentPage = context.select<AppModel, int>((appModel) => appModel.currentPage);
    MAIN_SCREEN currentScreen = context.select<AppModel, MAIN_SCREEN>((appModel) => appModel.currentScreen);

    /*List<Widget> drawerActions = <Widget>[
      Consumer<AppModel>(
        builder: (context, appModel, _) => IconButton(
          tooltip: AppLocalizations.of(context)!.reorder,
          icon: Icon(
            Icons.reorder,
            color: Colors.white,
          ),
          onPressed: () => appModel.changeOrderDrawer(context, getPropertyNameList(context)),
        ),
      ),
      IconButton(
        tooltip: AppLocalizations.of(context)!.settings,
        icon: Icon(
          Icons.settings,
          color: Colors.white,
        ),
        onPressed: () {
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
          Navigator.pushNamed(context, '/settings');
        },
      ),
    ];*/

    headerDrawer
      ..add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'resources/images/logo.png',
                width: 50,
                filterQuality: FilterQuality.medium,
              ),
              SizedBox(width: 10),
              Text(
                'Converter NOW',
                style: GoogleFonts.josefinSans(
                  textStyle: TextStyle(fontSize: 31),
                ),
              ),
            ],
          ),
        ),
      ))
      ..add(DrawerTile(
        leading: Icon(Icons.search_outlined),
        title: Text(AppLocalizations.of(context)!.search),
        onTap: () => widget.openSearch(),
        selected: false,
      ))
      ..add(DrawerTile(
        leading: Icon(Icons.clear_outlined),
        title: Text(AppLocalizations.of(context)!.clearAll),
        onTap: () {
          context.read<Conversions>().clearAllValues();
        },
        selected: false,
      ))
      ..add(
        DrawerTile(
          leading: Icon(Icons.calculate_outlined),
          title: Text(AppLocalizations.of(context)!.calculator),
          onTap: () => widget.openCalculator(),
          selected: false,
        ),
      )
      ..add(
        DrawerTile(
          leading: Icon(Icons.settings_outlined),
          title: Text(AppLocalizations.of(context)!.settings),
          onTap: () {
            if (!widget.isDrawerFixed) {
              Navigator.of(context).pop();
            }
            context.read<AppModel>().currentScreen = MAIN_SCREEN.SETTINGS;
          },
          selected: currentScreen == MAIN_SCREEN.SETTINGS,
        ),
      )
      ..add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black38),
        ),
      );

    List<int> conversionsOrderDrawer = context.watch<AppModel>().conversionsOrderDrawer;

    //*the following lines are more optimized then the prvious one but don't know
    //*why they don't work :(
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
            ..currentScreen = MAIN_SCREEN.CONVERSION;
          if (!widget.isDrawerFixed) {
            Navigator.of(context).pop();
          }
        },
        selected: currentScreen == MAIN_SCREEN.CONVERSION && currentPage == i,
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
