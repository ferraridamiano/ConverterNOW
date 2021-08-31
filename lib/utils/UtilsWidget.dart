import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    this.title,
    this.leading,
    this.onTap,
    this.selectedColor = Colors.transparent,
    this.selected = false,
  }) : super(key: key);

  final Widget? title;
  final Widget? leading;
  final void Function()? onTap;
  final Color selectedColor;
  final bool selected;

  static const BorderRadiusGeometry borderRadius = const BorderRadius.horizontal(right: Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? selectedColor : Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: ListTile(
        leading: leading,
        title: title,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
    );
  }
}

abstract class ListItem {}

class MyCard implements ListItem {
  MyCard({this.symbol, required this.textField});

  String? symbol;
  final Widget textField;
}

class BigHeader implements ListItem {
  BigHeader({required this.title, required this.subTitle});
  String title;
  String subTitle;
}

class BigTitle extends StatelessWidget {
  BigTitle({
    required this.text,
    required this.subtitle,
    required this.isCurrenciesLoading,
    required this.brightness,
  });
  final String text;
  final String subtitle;
  final bool isCurrenciesLoading;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            maxLines: 2,
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: brightness == Brightness.dark ? Color(0xFFDDDDDD) : Color(0xFF666666),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            subtitle != ''
                ? Container(
                    height: 17.0,
                    alignment: Alignment.bottomRight,
                    child: (isCurrenciesLoading && subtitle != "")
                        ? Container(
                            padding: EdgeInsets.only(right: 10),
                            child: CircularProgressIndicator(),
                            height: 15.0,
                            width: 25.0,
                          )
                        : Text(
                            subtitle,
                            style: TextStyle(fontSize: 15.0, color: Color(0xFF999999)),
                          ),
                  )
                : SizedBox(),
            Divider(
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }
}

class UnitCard extends StatelessWidget {
  UnitCard({required this.symbol, required this.textField});

  final String? symbol;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 14.0),
          child: new Card(
            child: Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0), child: this.textField),
            elevation: 4.0,
          ),
        ),
        symbol == null
            ? SizedBox()
            : Align(
                alignment: Alignment(0.95, -0.9),
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      symbol!,
                      style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ),
      ],
    );
  }
}

class SearchUnit {
  String iconAsset;
  String unitName;
  GestureTapCallback onTap;
  SearchUnit({required this.iconAsset, required this.unitName, required this.onTap});
}

class SearchUnitTile extends StatelessWidget {
  final SearchUnit searchUnit;
  final bool darkMode;
  SearchUnitTile(this.searchUnit, this.darkMode);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(searchUnit.iconAsset, height: 26.0, color: darkMode ? Colors.white : Colors.grey),
      title: Text(searchUnit.unitName),
      onTap: searchUnit.onTap,
    );
  }
}

class SuggestionList extends StatelessWidget {
  final List<SearchUnit> suggestions;
  final bool darkMode;
  SuggestionList({required this.suggestions, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[for (int i = 0; i < suggestions.length; i++) SearchUnitTile(suggestions[i], darkMode)],
    );
  }
}

class SearchGridTile extends StatelessWidget {
  final String iconAsset;
  final String footer;
  final GestureTapCallback onTap;
  final bool darkMode;
  SearchGridTile({
    required this.iconAsset,
    required this.footer,
    required this.onTap,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: GridTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 55.0,
                height: 55.0,
                child: Image.asset(iconAsset, color: darkMode ? Colors.white : Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                footer,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}