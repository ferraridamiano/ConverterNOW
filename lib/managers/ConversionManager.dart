import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/pages/ConversionPage.dart';
import 'package:converterpro/utils/Localization.dart';
import 'package:converterpro/utils/UnitsData.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import "dart:convert";
import 'package:provider/provider.dart';

Map jsonSearch;

class ConversionManager extends StatelessWidget {
  final Function openDrawer;
  final List<String> titlesList;
  final String lastUpdateCurrency;

  ConversionManager({this.openDrawer, this.titlesList, this.lastUpdateCurrency});

  final SearchDelegate _searchDelegate = CustomSearchDelegate();

  _getJsonSearch(BuildContext context) async {
    jsonSearch ??= json.decode(
      await DefaultAssetBundle.of(context)
          .loadString("resources/lang/${Localizations.localeOf(context).languageCode}.json"),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getJsonSearch(context);

    List<Choice> choices = <Choice>[
      Choice(title: MyLocalizations.of(context).trans('riordina'), icon: Icons.reorder),
    ];

    return Consumer2<AppModel, Conversions>(
      builder: (context, appModel, conversions, _) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: ConversionPage(
            conversions.conversionsList[appModel.currentPage],
            titlesList[appModel.currentPage],
            appModel.currentPage == 11 ? lastUpdateCurrency : "",
            MediaQuery.of(context),
            conversions.isCurrenciesLoading,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Builder(builder: (context) {
                return IconButton(
                    tooltip: MyLocalizations.of(context).trans('menu'),
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      openDrawer();
                    });
              }),
              Row(
                children: <Widget>[
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('elimina_tutto'),
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      conversions.clearValues(appModel.currentPage);
                    },
                  ),
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('cerca'),
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final int newPage = await showSearch(context: context, delegate: _searchDelegate);
                      if (newPage != null) {
                        AppModel appModel = context.read<AppModel>();
                        if (appModel.currentPage != newPage) appModel.changeToPage(newPage);
                      }
                    },
                  ),
                  PopupMenuButton<Choice>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (Choice choice) {
                      List<String> listTranslatedUnits = List();
                      for (String stringa
                          in conversions.conversionsList[appModel.currentPage].getStringOrderedNodiFiglio())
                        listTranslatedUnits.add(MyLocalizations.of(context).trans(stringa));
                      conversions.changeOrderUnits(context, listTranslatedUnits, appModel.currentPage);
                    },
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
        floatingActionButton: FloatingActionButton(
          tooltip: MyLocalizations.of(context).trans('calcolatrice'),
          child: Image.asset(
            "resources/images/calculator.png",
            width: 30.0,
          ),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  double displayWidth = MediaQuery.of(context).size.width;
                  return Calculator(Theme.of(context).accentColor, displayWidth);
                });
          },
          elevation: 5.0,
          backgroundColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class CustomSearchDelegate extends SearchDelegate<int> {
  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: MyLocalizations.of(context).trans('back'),
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<SearchUnit> _dataSearch = initializeSearchUnits((int pageNumber) {
      close(context, pageNumber);
    }, jsonSearch);
    final List<SearchGridTile> allConversions = initializeGridSearch((int pageNumber) {
      close(context, pageNumber);
    }, jsonSearch, MediaQuery.of(context).platformBrightness == Brightness.dark);

    final Iterable<SearchUnit> suggestions = _dataSearch.where((searchUnit) =>
        searchUnit.unitName.toLowerCase().contains(query.toLowerCase())); //.toLowercase in order to be case insesitive

    return query.isNotEmpty
        ? SuggestionList(
            suggestions: suggestions.toList(),
            darkMode: MediaQuery.of(context).platformBrightness == Brightness.dark,
          )
        : GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200.0),
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
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
}
