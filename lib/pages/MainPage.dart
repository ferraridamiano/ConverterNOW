import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Calculator.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/pages/CalculatorWidget.dart';
import 'package:converterpro/pages/ChoosePropertyPage.dart';
import 'package:converterpro/pages/ConversionPage.dart';
import 'package:converterpro/pages/CustomDrawer.dart';
import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/pages/SettingsPage.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:converterpro/utils/UtilsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final double displayWidth = MediaQuery.of(context).size.width;

    final VoidCallback openCalculator = () {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider(
              create: (_) => Calculator(decimalSeparator: '.'),
              child: CalculatorWidget(displayWidth, Theme.of(context).brightness),
            );
          });
    };
    final VoidCallback clearAll = () => context.read<Conversions>().clearAllValues();

    final VoidCallback openSearch = () async {
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

    // Read the order of the properties in the drawer
    List<int> conversionsOrderDrawer = context.read<AppModel>().conversionsOrderDrawer;
    List<String> propertyNameList = getPropertyNameList(context);
    List<String> orderedDrawerList = List.filled(conversionsOrderDrawer.length, "");
    for (int i = 0; i < conversionsOrderDrawer.length; i++) {
      orderedDrawerList[conversionsOrderDrawer[i]] = propertyNameList[i];
    }

    // Get the current main screen
    MAIN_SCREEN currentScreen = context.select<AppModel, MAIN_SCREEN>((appModel) => appModel.currentScreen);
    // And build the right widget
    Widget mainScreen;
    switch (currentScreen) {
      case MAIN_SCREEN.SETTINGS:
        mainScreen = SettingsPage();
        break;
      case MAIN_SCREEN.REORDER_PROPERTIES:
        mainScreen = ReorderPage(
          itemsList: orderedDrawerList,
          onSave: (List<int>? orderList) {
            context.read<AppModel>()
              ..saveOrderDrawer(orderList)
              ..currentScreen = MAIN_SCREEN.SETTINGS;
          },
        );
        break;
      case MAIN_SCREEN.REORDER_UNITS:
        mainScreen = ChoosePropertyPage(orderedDrawerList);
        break;
      case MAIN_SCREEN.CONVERSION:
      default:
        mainScreen = ConversionPage();
        break;
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final bool _isDrawerFixed = isDrawerFixed(constraints.maxWidth);

      Widget drawer = CustomDrawer(
        isDrawerFixed: _isDrawerFixed,
        openCalculator: openCalculator,
        openSearch: openSearch,
      );

      //if the drawer is fixed
      if (_isDrawerFixed) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                drawer,
                mainScreen,
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.clear_outlined),
            backgroundColor: Color(0xFFFF0000),
            onPressed: clearAll,
            tooltip: AppLocalizations.of(context)!.clearAll,
          ),
        );
      }
      // if the drawer is not fixed
      return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: drawer,
        body: SafeArea(
            child: Row(
          children: [
            mainScreen,
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Builder(builder: (context) {
                return IconButton(
                    tooltip: AppLocalizations.of(context)!.menu,
                    icon: Icon(
                      Icons.menu,
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
                    onPressed: openSearch,
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.calculator,
          child: Icon(
            Icons.calculate_outlined,
            size: 35,
          ),
          onPressed: openCalculator,
          elevation: 5.0,
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
    });
  }
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

    final Iterable<SearchUnit> suggestions = _dataSearch.where((searchUnit) =>
        searchUnit.unitName.toLowerCase().contains(query.toLowerCase())); //.toLowercase in order to be case insesitive

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
