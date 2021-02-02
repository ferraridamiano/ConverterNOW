import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/pages/ConversionPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:converterpro/utils/Translation.dart';

class AppManager extends StatelessWidget {
  static const MAX_CONVERSION_UNITS = 19;

  static List<Widget> listaDrawer = List(MAX_CONVERSION_UNITS + 1); //+1 because of the header

  void _initializeTiles(BuildContext context) {
    List<String> titlesList = getPropertyTranslationList(context);
    Color boxColor = Theme.of(context).primaryColor;

    List<Widget> drawerActions = <Widget>[
      Consumer<AppModel>(
        builder: (context, appModel, _) => IconButton(
          tooltip: AppLocalizations.of(context).reorder,
          icon: Icon(
            Icons.reorder,
            color: Colors.white,
          ),
          //onPressed: () => appModel.changeOrderDrawer(context, titlesList),
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

    listaDrawer[conversionsOrderDrawer[0] + 1] = ListTileConversion(
      titlesList[0],
      "resources/images/angles.png",
      currentPage == 0,
      () {
        context.read<AppModel>().changeToPage(0);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[1] + 1] = ListTileConversion(
      titlesList[1],
      "resources/images/area.png",
      currentPage == 1,
      () {
        context.read<AppModel>().changeToPage(1);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[2] + 1] = ListTileConversion(
      titlesList[2],
      "resources/images/currencies.png",
      currentPage == 2,
      () {
        context.read<AppModel>().changeToPage(2);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[3] + 1] = ListTileConversion(
      titlesList[3],
      "resources/images/data.png",
      currentPage == 3,
      () {
        context.read<AppModel>().changeToPage(3);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[4] + 1] = ListTileConversion(
      titlesList[4],
      "resources/images/energy.png",
      currentPage == 4,
      () {
        context.read<AppModel>().changeToPage(4);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[5] + 1] = ListTileConversion(
      titlesList[5],
      "resources/images/force.png",
      currentPage == 5,
      () {
        context.read<AppModel>().changeToPage(5);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[6] + 1] = ListTileConversion(
      titlesList[6],
      "resources/images/fuel.png",
      currentPage == 6,
      () {
        context.read<AppModel>().changeToPage(6);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[7] + 1] = ListTileConversion(
      titlesList[7],
      "resources/images/length.png",
      currentPage == 7,
      () {
        context.read<AppModel>().changeToPage(7);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[8] + 1] = ListTileConversion(
      titlesList[8],
      "resources/images/mass.png",
      currentPage == 8,
      () {
        context.read<AppModel>().changeToPage(8);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[9] + 1] = ListTileConversion(
      titlesList[9],
      "resources/images/num_systems.png",
      currentPage == 9,
      () {
        context.read<AppModel>().changeToPage(9);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[10] + 1] = ListTileConversion(
      titlesList[10],
      "resources/images/power.png",
      currentPage == 10,
      () {
        context.read<AppModel>().changeToPage(10);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[11] + 1] = ListTileConversion(
      titlesList[11],
      "resources/images/pressure.png",
      currentPage == 11,
      () {
        context.read<AppModel>().changeToPage(11);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[12] + 1] = ListTileConversion(
      titlesList[12],
      "resources/images/shoe_size.png",
      currentPage == 12,
      () {
        context.read<AppModel>().changeToPage(12);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[13] + 1] = ListTileConversion(
      titlesList[13],
      "resources/images/prefixes.png",
      currentPage == 13,
      () {
        context.read<AppModel>().changeToPage(13);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[14] + 1] = ListTileConversion(
      titlesList[14],
      "resources/images/speed.png",
      currentPage == 14,
      () {
        context.read<AppModel>().changeToPage(14);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[15] + 1] = ListTileConversion(
      titlesList[15],
      "resources/images/temperature.png",
      currentPage == 15,
      () {
        context.read<AppModel>().changeToPage(15);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[16] + 1] = ListTileConversion(
      titlesList[16],
      "resources/images/time.png",
      currentPage == 16,
      () {
        context.read<AppModel>().changeToPage(16);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[17] + 1] = ListTileConversion(
      titlesList[17],
      "resources/images/torque.png",
      currentPage == 17,
      () {
        context.read<AppModel>().changeToPage(17);
        Navigator.of(context).pop();
      },
    );
    listaDrawer[conversionsOrderDrawer[18] + 1] = ListTileConversion(
      titlesList[18],
      "resources/images/volume.png",
      currentPage == 18,
      () {
        context.read<AppModel>().changeToPage(18);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _initializeTiles(context);

    DateTime lastUpdateCurrencies = context.select<Conversions, DateTime>(
      (settings) => settings.lastUpdateCurrency,
    );

    String stringLastUpdateCurrencies;
    DateTime dateNow = DateTime.now();
    if (lastUpdateCurrencies.day == dateNow.day && lastUpdateCurrencies.month == dateNow.month && lastUpdateCurrencies.year == dateNow.year)
      stringLastUpdateCurrencies = AppLocalizations.of(context).lastCurrenciesUpdate + AppLocalizations.of(context).today;
    else
      stringLastUpdateCurrencies = AppLocalizations.of(context).lastCurrenciesUpdate + DateFormat("yyyy-MM-dd").format(lastUpdateCurrencies);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
        ),
      ),
      body: Builder(
        builder: (context) => ConversionPage(
          openDrawer: () {
            Scaffold.of(context).openDrawer();
          },
          lastUpdateCurrency: stringLastUpdateCurrencies,
        ),
      ),
    );
  }
}
