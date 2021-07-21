import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Calculator.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'CalculatorWidget.dart';
import 'ConversionPage.dart';
import 'ReorderPage.dart';

class ConversionScaffold extends StatelessWidget {
  static const MAX_CONVERSION_UNITS = 19;

  Drawer _getDrawer(BuildContext context, bool isDrawerFixed) {
    List<Widget> listaDrawer = List<Widget>.filled(MAX_CONVERSION_UNITS + 1, SizedBox()); //+1 because of the header
    Color boxColor = Theme.of(context).primaryColor;

    List<Widget> drawerActions = <Widget>[
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
                    child: Image.asset("resources/images/logo.png", filterQuality: FilterQuality.medium),
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
        onTap: () {
          context.read<AppModel>().changeToPage(i);
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        },
        brightness: getBrightness(
          context.select<AppModel, ThemeMode>((AppModel appModel) => appModel.currentThemeMode),
          MediaQuery.of(context).platformBrightness,
        ),
      );
    }

    return Drawer(
      child: ListView(
        controller: ScrollController(),
        padding: EdgeInsets.zero,
        children: listaDrawer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = <Choice>[
      Choice(title: AppLocalizations.of(context)!.reorder, icon: Icons.reorder),
    ];

    Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);

    Brightness brightness = getBrightness(
      context.select<AppModel, ThemeMode>((AppModel appModel) => appModel.currentThemeMode),
      MediaQuery.of(context).platformBrightness,
    );
    double displayWidth = MediaQuery.of(context).size.width;
    bool _isDrawerFixed = isDrawerFixed(displayWidth);
    context.read<AppModel>().isDrawerFixed = _isDrawerFixed;

    final VoidCallback openCalculator = () {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider(
              create: (_) => Calculator(decimalSeparator: '.'),
              child: CalculatorWidget(displayWidth, brightness),
            );
          });
    };
    final VoidCallback clearAll = () {
      Conversions conversions = context.read<Conversions>();
      conversions.clearAllValues();
    };
    final VoidCallback search = () async {
      final orderList = context.read<AppModel>().conversionsOrderDrawer;
      final int? newPage = await showSearch(
        context: context,
        delegate: CustomSearchDelegate(orderList),
      );
      if (newPage != null) {
        AppModel appModel = context.read<AppModel>();
        if (appModel.currentPage != newPage) appModel.changeToPage(newPage);
      }
    };

    // don't work
    final VoidCallback reorderUnits = () async {
      //List<String> listUnitsNames = List.generate(unitDataList.length, (index) => unitTranslationMap[unitDataList[index].unit.name]!);
      /*final List<int>? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReorderPage(listUnitsNames),
        ),
      );
      context.read<Conversions>().changeOrderUnits(result);*/
    };

    // Needed in order to open/close the speedDial with the back button
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    PROPERTYX currentProperty = context.select<Conversions, PROPERTYX>((conversions) => conversions.currentPropertyName);
    List<UnitData> unitDataList = context.select<Conversions, List<UnitData>>((conversions) => conversions.currentUnitDataList);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: _isDrawerFixed ? null : _getDrawer(context, _isDrawerFixed),
      body: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _isDrawerFixed ? _getDrawer(context, _isDrawerFixed) : SizedBox(),
              Expanded(
                child: ConversionPage(currentProperty, unitDataList),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: isDrawerFixed(displayWidth) ? FloatingActionButtonLocation.endFloat : FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _isDrawerFixed
          ? null
          : BottomAppBar(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Builder(builder: (context) {
                    return IconButton(
                        tooltip: AppLocalizations.of(context)!.menu,
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        });
                  }),
                  Row(
                    children: <Widget>[
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.clearAll,
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: clearAll,
                      ),
                      IconButton(
                        // search
                        tooltip: AppLocalizations.of(context)!.search,
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: search,
                      ),
                      PopupMenuButton<Choice>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (Choice choice) => reorderUnits(),
                        itemBuilder: (BuildContext context) {
                          return choices.map((Choice choice) {
                            return PopupMenuItem<Choice>(
                              value: choice,
                              child: Text(choice.title),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
      floatingActionButton: _isDrawerFixed
          ? SpeedDial(
              openCloseDial: isDialOpen,
              icon: Icons.add,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              activeIcon: Icons.clear,
              tooltip: AppLocalizations.of(context)?.more,
              brightness: getBrightness(
                context.select<AppModel, ThemeMode>((appModel) => appModel.currentThemeMode),
                MediaQuery.of(context).platformBrightness,
              ),
              elevation: 8.0,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.calculate),
                  backgroundColor: Theme.of(context).accentColor,
                  foregroundColor: Colors.white,
                  label: AppLocalizations.of(context)?.calculator,
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: openCalculator,
                ),
                SpeedDialChild(
                  child: Icon(Icons.clear),
                  backgroundColor: Theme.of(context).accentColor,
                  foregroundColor: Colors.white,
                  label: AppLocalizations.of(context)?.clearAll,
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: clearAll,
                ),
                SpeedDialChild(
                  child: Icon(Icons.search),
                  backgroundColor: Theme.of(context).accentColor,
                  foregroundColor: Colors.white,
                  label: AppLocalizations.of(context)?.search,
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: search,
                ),
                SpeedDialChild(
                  child: Icon(Icons.reorder),
                  backgroundColor: Theme.of(context).accentColor,
                  foregroundColor: Colors.white,
                  label: AppLocalizations.of(context)?.reorder,
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: reorderUnits,
                ),
              ],
            )
          : FloatingActionButton(
              tooltip: AppLocalizations.of(context)!.calculator,
              child: Icon(
                Icons.calculate,
                size: 35,
              ),
              onPressed: openCalculator,
              elevation: 5.0,
              backgroundColor: Theme.of(context).accentColor,
            ),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class CustomSearchDelegate extends SearchDelegate<int> {
  final List<int> orderList;

  CustomSearchDelegate(this.orderList);

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context)!.back,
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, 0);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Brightness brightness = getBrightness(
      context.select<AppModel, ThemeMode>((AppModel appModel) => appModel.currentThemeMode),
      MediaQuery.of(context).platformBrightness,
    );

    final List<SearchUnit> _dataSearch = getSearchUnitsList((int pageNumber) {
      close(context, pageNumber);
    }, context);
    final List<SearchGridTile> allConversions = initializeGridSearch(
      (int pageNumber) {
        close(context, pageNumber);
      },
      context,
      brightness == Brightness.dark,
      orderList,
    );

    final Iterable<SearchUnit> suggestions =
        _dataSearch.where((searchUnit) => searchUnit.unitName.toLowerCase().contains(query.toLowerCase())); //.toLowercase in order to be case insesitive

    return query.isNotEmpty
        ? SuggestionList(
            suggestions: suggestions.toList(),
            darkMode: brightness == Brightness.dark,
          )
        : GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180.0),
            children: allConversions,
          );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          tooltip: AppLocalizations.of(context)!.clearAll,
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
}
