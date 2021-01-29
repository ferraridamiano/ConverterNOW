import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/utils/Localization.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:units_converter/units_converter.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/utils/SearchUnit.dart';
import "dart:convert";

Map jsonSearch;

class ConversionPage extends StatelessWidget {
  final Function openDrawer;
  final List<String> titlesList;
  final String lastUpdateCurrency;
  List<TextEditingController> listaController = [];
  List<FocusNode> listaFocus = [];
  List listaNodi;

  ConversionPage({this.openDrawer, this.titlesList, this.lastUpdateCurrency});

  final SearchDelegate _searchDelegate = CustomSearchDelegate();

  _getJsonSearch(BuildContext context) async {
    jsonSearch ??= json.decode(
      await DefaultAssetBundle.of(context).loadString("resources/lang/${Localizations.localeOf(context).languageCode}.json"),
    );
  }

  /*@override
  void initState() {
    initialize();
    super.initState();
  }*/

  /*void initialize() {
    for (Node node in listaNodi) {
      listaController.add(new TextEditingController());
      FocusNode focus = new FocusNode();
      focus.addListener(() {
        if (focus.hasFocus) {
          if (selectedNode != null) {
            selectedNode.selectedNode = false;
          }
          node.selectedNode = true;
          node.convertedNode = true;
          selectedNode = node;
        }
      });
      listaFocus.add(focus);
    }
  }*/

  /*@override
  void dispose() {
    FocusNode focus;
    TextEditingController tec;
    for (int i = 0; i < listaFocus.length; i++) {
      focus = listaFocus[i];
      focus.removeListener(() {});
      focus.dispose();
      tec = listaController[i];
      tec.dispose();
    }
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    _getJsonSearch(context);

    List<Choice> choices = <Choice>[
      Choice(title: MyLocalizations.of(context).trans('riordina'), icon: Icons.reorder),
    ];
    int currentPage = context.select<AppModel, int>((appModel) => appModel.currentPage);

    List<UnitData> unitDataList = context.select<Conversions, List<UnitData>>((conversions) => conversions.currentUnitDataList);
    //List<UnitData> unitDataList = context.watch<Conversions>().currentUnitData;
    UnitData selectedUnit = context.watch<Conversions>().selectedUnit;

    List<ListItem> itemList = [];
    itemList.add(
      BigHeader(
        title: titlesList[currentPage],
        subTitle: currentPage == 11 ? lastUpdateCurrency : "",
      ),
    );
    for (UnitData unitData in unitDataList) {
      /*if ((listaNodi[i].value != null || listaNodi[i].valueString != null) && !listaNodi[i].selectedNode) {
        if (listaNodi[i].keyboardType == KEYBOARD_NUMBER_DECIMAL)
          listaController[i].text = listaNodi[i].mantissaCorrection();
        else if (listaNodi[i].keyboardType == KEYBOARD_COMPLETE || listaNodi[i].keyboardType == KEYBOARD_NUMBER_INTEGER)
          listaController[i].text = listaNodi[i].valueString;
      } else if (!listaNodi[i].selectedNode &&
          ((listaNodi[i].keyboardType == KEYBOARD_NUMBER_DECIMAL && listaNodi[i].value == null) ||
              ((listaNodi[i].keyboardType == KEYBOARD_COMPLETE ||
                      listaNodi[i].keyboardType == KEYBOARD_NUMBER_INTEGER) &&
                  listaNodi[i].valueString == null))) {
        listaController[i].text = "";
      } else if (listaNodi[i].selectedNode && listaNodi[i].value == null && listaNodi[i].valueString == null)
        listaController[i].text = "";
      */
      itemList.add(
        MyCard(
          symbol: unitData.unit.symbol,
          textField: TextFormField(
            style: TextStyle(
              fontSize: 16.0,
              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
            ),
            keyboardType: unitData.textInputType,
            controller: unitData.tec,
            //focusNode: listaFocus[i],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String input) {
              if (input != "" && !unitData.getValidator().hasMatch(input)) {
                return MyLocalizations.of(context).trans('invalid_characters');
              }
              return null;
            },
            decoration: InputDecoration(labelText: MyLocalizations.of(context).trans(unitData.getTranslationKey()) //listaNodi[i].name,
                ),
            onChanged: (String txt) {
              Conversions conversions = context.read<Conversions>();
              //just numeral system uses a string for conversion
              if (unitData.unit.name == PROPERTY.NUMERAL_SYSTEMS) {
                conversions.convert(unitData, txt == "" ? null : txt);
              } else {
                conversions.convert(unitData, txt == "" ? null : double.parse(txt));
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
            isCurrenciesLoading: context.select<Conversions, bool>(
              (conversions) => conversions.isCurrenciesLoading,
            ),
          ),
        );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        /*child: ConversionPage(
            conversions.currentUnitData,
            conversions.currentProperty,
            titlesList[appModel.currentPage],
            appModel.currentPage == 11 ? lastUpdateCurrency : "",
            MediaQuery.of(context),
            conversions.isCurrenciesLoading,
          ),*/
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
                    Conversions conversions = context.read<Conversions>();
                    conversions.clearAllValues();
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
                    /*List<String> listTranslatedUnits = [];
                      for (String stringa
                          in conversions.conversionsList[appModel.currentPage].getStringOrderedNodiFiglio())
                        listTranslatedUnits.add(MyLocalizations.of(context).trans(stringa));
                      conversions.changeOrderUnits(context, listTranslatedUnits, appModel.currentPage);*/
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

    final Iterable<SearchUnit> suggestions =
        _dataSearch.where((searchUnit) => searchUnit.unitName.toLowerCase().contains(query.toLowerCase())); //.toLowercase in order to be case insesitive

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
//ConversionPage(this.unitDataList, this.currentProperty, this.title, this.subtitle, this.mediaQuery, this.isCurrenciesLoading);
