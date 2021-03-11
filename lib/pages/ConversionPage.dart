import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/Calculator.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:intl/intl.dart';
import 'CalculatorWidget.dart';
import 'ReorderPage.dart';

class ConversionPage extends StatelessWidget {
  final Function openDrawer;

  ConversionPage(this.openDrawer);

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = <Choice>[
      Choice(title: AppLocalizations.of(context)!.reorder, icon: Icons.reorder),
    ];

    Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    Map<PROPERTYX, String> propertyTranslationMap = getPropertyTranslationMap(context);
    List<UnitData> unitDataList = context.select<Conversions, List<UnitData>>((conversions) => conversions.currentUnitDataList);
    List<ListItem> itemList = [];
    PROPERTYX currentProperty = context.select<Conversions, PROPERTYX>((conversions) => conversions.currentPropertyName);

    Brightness brightness = getBrightness(
      context.select<AppModel, ThemeMode>((AppModel appModel) => appModel.currentThemeMode),
      MediaQuery.of(context).platformBrightness,
    );
    String subTitle = '';
    if (currentProperty == PROPERTYX.CURRENCIES) {
      subTitle = getLastUpdateString(context);
    }

    itemList.add(
      BigHeader(
        title: propertyTranslationMap[currentProperty]!,
        subTitle: subTitle,
      ),
    );
    for (UnitData unitData in unitDataList) {
      itemList.add(
        MyCard(
          symbol: unitData.unit.symbol,
          textField: TextFormField(
            key: Key(unitData.unit.name.toString()),
            style: TextStyle(
              fontSize: 16.0,
              color: brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
            keyboardType: unitData.textInputType,
            controller: unitData.tec,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? input) {
              if (input != null && input != '' && !unitData.getValidator().hasMatch(input)) {
                return AppLocalizations.of(context)!.invalidCharacters;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: unitTranslationMap[unitData.unit.name],
            ),
            onChanged: (String txt) {
              if (txt == '' || unitData.getValidator().hasMatch(txt)) {
                Conversions conversions = context.read<Conversions>();
                //just numeral system uses a string for conversion
                if (unitData.property == PROPERTYX.NUMERAL_SYSTEMS) {
                  conversions.convert(unitData, txt == "" ? null : txt);
                } else {
                  conversions.convert(unitData, txt == "" ? null : double.parse(txt));
                }
              }
            },
          ),
        ),
      );
    }

    List<Widget> gridTiles = [];
    for (ListItem item in itemList) {
      if (item is MyCard) {
        gridTiles.add(UnitCard(
          symbol: item.symbol,
          textField: item.textField,
        ));
      } else if (item is BigHeader) {
        gridTiles.add(
          BigTitle(
            text: item.title,
            subtitle: item.subTitle,
            isCurrenciesLoading: context.select<Conversions, bool>((conversions) => conversions.isCurrenciesLoading),
            brightness: brightness,
          ),
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: responsivePadding(MediaQuery.of(context)),
            child: GridView.count(
              childAspectRatio: responsiveChildAspectRatio(MediaQuery.of(context)),
              crossAxisCount: responsiveNumGridTiles(MediaQuery.of(context)),
              shrinkWrap: true,
              crossAxisSpacing: 15.0,
              children: gridTiles,
              padding: EdgeInsets.only(bottom: 22), //So FAB doesn't overlap the card
            ),
          ),
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
                  tooltip: AppLocalizations.of(context)!.menu,
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
                  tooltip: AppLocalizations.of(context)!.clearAll,
                  icon: Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    Conversions conversions = context.read<Conversions>();
                    conversions.clearAllValues();
                  },
                ),
                IconButton(
                  // search
                  tooltip: AppLocalizations.of(context)!.search,
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final orderList = context.read<AppModel>().conversionsOrderDrawer;
                    final int? newPage = await showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(orderList),
                    );
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
                  onSelected: (Choice choice) async {
                    //Let's generate the list of unit name in the current order
                    List<String> listUnitsNames = List.generate(unitDataList.length, (index) => unitTranslationMap[unitDataList[index].unit.name]!);
                    final List<int>? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReorderPage(listUnitsNames),
                      ),
                    );
                    context.read<Conversions>().changeOrderUnits(result);
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
        tooltip: AppLocalizations.of(context)!.calculator,
        child: Image.asset(
          "resources/images/calculator.png",
          width: 30.0,
        ),
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                double displayWidth = MediaQuery.of(context).size.width;
                return ChangeNotifierProvider(
                  create: (_) => Calculator(),
                  child: CalculatorWidget(Theme.of(context).accentColor, displayWidth, brightness),
                );
              });
        },
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

String getLastUpdateString(BuildContext context) {
  DateTime lastUpdateCurrencies = context.select<Conversions, DateTime>((settings) => settings.lastUpdateCurrency);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day && lastUpdateCurrencies.month == dateNow.month && lastUpdateCurrencies.year == dateNow.year) {
    return AppLocalizations.of(context)!.lastCurrenciesUpdate + AppLocalizations.of(context)!.today;
  }
  return AppLocalizations.of(context)!.lastCurrenciesUpdate + DateFormat("yyyy-MM-dd").format(lastUpdateCurrencies);
}
