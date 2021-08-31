import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/Calculator.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/utils/UtilsWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:intl/intl.dart';
import 'package:converterpro/pages/CalculatorWidget.dart';
import 'package:converterpro/pages/ReorderPage.dart';

class ConversionPage extends StatelessWidget {
  static const MAX_CONVERSION_UNITS = 19;

  Drawer _getDrawer(BuildContext context, bool isDrawerFixed, Brightness brightness, double displayWidth) {
    late List<Widget> headerDrawer = [];
    List<Widget> conversionDrawer = List<Widget>.filled(MAX_CONVERSION_UNITS, SizedBox());

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
        onTap: () async {
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
        selectedColor: Colors.teal,
        selected: false,
      ))
      ..add(DrawerTile(
        leading: Icon(Icons.clear_outlined),
        title: Text(AppLocalizations.of(context)!.clearAll),
        onTap: () {
          Conversions conversions = context.read<Conversions>();
          conversions.clearAllValues();
        },
        selectedColor: Colors.teal,
        selected: false,
      ))
      ..add(
        DrawerTile(
          leading: Icon(Icons.calculate_outlined),
          title: Text(AppLocalizations.of(context)!.calculator),
          onTap: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return ChangeNotifierProvider(
                    create: (_) => Calculator(decimalSeparator: '.'),
                    child: CalculatorWidget(displayWidth, brightness),
                  );
                });
          },
          selectedColor: Colors.teal,
          selected: false,
        ),
      )
      ..add(
        DrawerTile(
          leading: Icon(Icons.settings_outlined),
          title: Text(AppLocalizations.of(context)!.settings),
          onTap: () {
            if (!isDrawerFixed) {
              Navigator.of(context).pop();
            }
            Navigator.pushNamed(context, '/settings');
          },
          selectedColor: Colors.teal,
          selected: false,
        ),
      )
      ..add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Divider(color: brightness == Brightness.dark ? Colors.white : Colors.black),
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
      conversionDrawer[conversionsOrderDrawer[i]] = DrawerTile(
        leading: Image.asset(
          propertyUi.imagePath,
          width: 30,
          height: 30,
          color: Colors.white,
          filterQuality: FilterQuality.medium,
        ),
        title: Text(propertyUi.name),
        onTap: () {
          context.read<AppModel>().changeToPage(i);
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        },
        selected: currentPage == i,
        selectedColor: Colors.teal,
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

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = <Choice>[
      Choice(title: AppLocalizations.of(context)!.reorder, icon: Icons.reorder),
    ];

    Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    Map<PROPERTYX, String> propertyTranslationMap = getPropertyTranslationMap(context);
    List<UnitData> unitDataList =
        context.select<Conversions, List<UnitData>>((conversions) => conversions.currentUnitDataList);
    PROPERTYX currentProperty =
        context.select<Conversions, PROPERTYX>((conversions) => conversions.currentPropertyName);

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
    final VoidCallback reorderUnits = () async {
      List<String> listUnitsNames =
          List.generate(unitDataList.length, (index) => unitTranslationMap[unitDataList[index].unit.name]!);
      final List<int>? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReorderPage(listUnitsNames),
        ),
      );
      context.read<Conversions>().changeOrderUnits(result);
    };

    String subTitle = '';
    if (currentProperty == PROPERTYX.CURRENCIES) {
      subTitle = getLastUpdateString(context);
    }

    List<Widget> gridTiles = [];

    for (UnitData unitData in unitDataList) {
      gridTiles.add(UnitCard(
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
      ));
    }

    double xPadding = responsivePadding(displayWidth);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: _isDrawerFixed ? null : _getDrawer(context, _isDrawerFixed, brightness, displayWidth),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _isDrawerFixed ? _getDrawer(context, _isDrawerFixed, brightness, displayWidth) : SizedBox(),
            Expanded(
              child: CustomScrollView(
                controller: ScrollController(),
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: BigTitle(
                      text: propertyTranslationMap[currentProperty]!,
                      subtitle: subTitle,
                      isCurrenciesLoading:
                          context.select<Conversions, bool>((conversions) => conversions.isCurrenciesLoading),
                      brightness: brightness,
                      sidePadding: xPadding,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      right: xPadding,
                      left: xPadding,
                      bottom: 22, //bottom so FAB doesn't overlap the card
                    ),
                    sliver: SliverGrid.count(
                      childAspectRatio: responsiveChildAspectRatio(displayWidth),
                      crossAxisCount: responsiveNumGridTiles(displayWidth),
                      crossAxisSpacing: 15.0,
                      children: gridTiles,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: isDrawerFixed(displayWidth)
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.centerDocked,
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
          ? /*SpeedDial(
              openCloseDial: isDialOpen,
              icon: Icons.add,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              activeIcon: Icons.clear,
              tooltip: AppLocalizations.of(context)?.more,
              elevation: 8.0,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.reorder),
                  backgroundColor: Theme.of(context).accentColor,
                  foregroundColor: Colors.white,
                  label: AppLocalizations.of(context)?.reorder,
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: reorderUnits,
                ),
              ],
            )*/
          null
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

String getLastUpdateString(BuildContext context) {
  DateTime lastUpdateCurrencies = context.select<Conversions, DateTime>((settings) => settings.lastUpdateCurrency);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day &&
      lastUpdateCurrencies.month == dateNow.month &&
      lastUpdateCurrencies.year == dateNow.year) {
    return AppLocalizations.of(context)!.lastCurrenciesUpdate + AppLocalizations.of(context)!.today;
  }
  return AppLocalizations.of(context)!.lastCurrenciesUpdate +
      DateFormat.yMd(Localizations.localeOf(context).languageCode).format(lastUpdateCurrencies);
}

class MyCollapsingImage extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.red,
    );
  }

  @override
  double get maxExtent => 200.0;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
