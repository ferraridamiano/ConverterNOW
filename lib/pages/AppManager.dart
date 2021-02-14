import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/pages/ConversionPage.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppManager extends StatelessWidget {
  static const MAX_CONVERSION_UNITS = 19;

  static List<Widget> listaDrawer = List<Widget>.filled(MAX_CONVERSION_UNITS + 1, null); //+1 because of the header

  void _initializeTiles(BuildContext context) {
    Color boxColor = Theme.of(context).primaryColor;

    List<Widget> drawerActions = <Widget>[
      Consumer<AppModel>(
        builder: (context, appModel, _) => IconButton(
          tooltip: AppLocalizations.of(context).reorder,
          icon: Icon(
            Icons.reorder,
            color: Colors.white,
          ),
          onPressed: () => appModel.changeOrderDrawer(context, getPropertyNameList(context)),
        ),
      ),
      IconButton(
        tooltip: AppLocalizations.of(context).settings,
        icon: Icon(
          Icons.settings,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, '/settings');
        },
      ),
    ];

    bool logoVisibility = context.select<AppModel, bool>(
      (appModel) => appModel.isLogoVisible,
    );

    listaDrawer[0] = logoVisibility
        ? Container(
            decoration: BoxDecoration(color: boxColor),
            child: SafeArea(
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Image.asset("resources/images/logo.png"),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: boxColor,
                    ),
                  ),
                  Container(
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: drawerActions),
                    height: 160.0,
                    alignment: FractionalOffset.bottomRight,
                  )
                ],
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: drawerActions,
              ),
            ),
          );

    List<int> conversionsOrderDrawer = context.watch<AppModel>().conversionsOrderDrawer;

    //*the following lines are more optimized then the prvious one but don't know
    //*why they don't work :(
    /*List<int> conversionsOrderDrawer = context.select<AppModel, List<int>>(
      (appModel) => appModel.conversionsOrderDrawer
    );*/
    int currentPage = context.select<AppModel, int>((appModel) => appModel.currentPage);

    List<PropertyUi> propertyUiList = getPropertyUiList(context);

    for (int i = 0; i < propertyUiList.length; i++) {
      PropertyUi propertyUi = propertyUiList[i];
      listaDrawer[conversionsOrderDrawer[i] + 1] = ListTileConversion(
        text: propertyUi.name,
        imagePath: propertyUi.imagePath,
        selected: currentPage == i,
        onTapFunction: () {
          context.read<AppModel>().changeToPage(i);
          Navigator.of(context).pop();
        },
        brightness: getBrightness(
          context.select<AppModel, ThemeMode>((AppModel appModel) => appModel.currentThemeMode),
          MediaQuery.of(context).platformBrightness,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeTiles(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
        ),
      ),
      body: Builder(
        builder: (context) => ConversionPage(() {
          Scaffold.of(context).openDrawer();
        }),
      ),
    );
  }
}
