import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    this.title,
    this.leading,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  final Widget? title;
  final Widget? leading;
  final void Function()? onTap;
  final bool selected;

  static const BorderRadiusGeometry borderRadius = const BorderRadius.horizontal(right: Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).primaryColor.withOpacity(0.25) : Colors.transparent,
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

class BigTitle extends StatelessWidget {
  BigTitle({
    required this.text,
    this.subtitle = '',
    this.isSubtitleLoading = false,
    this.sidePadding = 0,
    this.center = false,
  });
  final String text;
  final String subtitle;
  final bool isSubtitleLoading;
  final double sidePadding;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final Widget title = Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFDDDDDD) : Color(0xFF666666),
      ),
      textAlign: center ? TextAlign.center : null,
    );

    return Padding(
      padding: EdgeInsets.only(left: sidePadding, right: sidePadding, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          center ? Center(child: title) : title,
          Container(
            height: 17.0,
            alignment: Alignment.bottomRight,
            child: (isSubtitleLoading && subtitle != '')
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black38,
            ),
          ),
        ],
      ),
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
                  color: Theme.of(context).primaryColor,
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

class DropdownListTile extends StatelessWidget {
  final String title;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final TextStyle textStyle;

  DropdownListTile({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    String selected = value;

    final bool isMobileDevice = !kIsWeb && (Platform.isIOS || Platform.isAndroid);

    if (isMobileDevice) {
      return ListTile(
        title: Text(
          title,
          style: textStyle,
        ),
        subtitle: Text(value),
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text(title),
            children: items.map<Widget>((String item) {
              return RadioListTile(
                  title: Text(item),
                  value: item,
                  groupValue: selected,
                  onChanged: (String? val) {
                    onChanged(val);
                    Navigator.pop(context); // Close dialog
                  });
            }).toList(),
          ),
        ),
      );
    }

    return ListTile(
      title: Text(
        title,
        style: textStyle,
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((String item) {
            return Center(
                child: Text(
              item,
              style: textStyle,
            ));
          }).toList();
        },
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            child: Text(
              item.toString(),
              style: textStyle,
            ),
            value: item,
          );
        }).toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String? text;
  final double buttonWidth;
  final double buttonHeight;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final TextStyle? style;
  final Color? iconColor;

  const CalculatorButton({
    Key? key,
    this.text,
    required this.buttonHeight,
    required this.buttonWidth,
    this.onLongPress,
    this.onPressed,
    this.style,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: brightness == Brightness.dark ? Colors.white24 : Colors.black26,
      primary: Colors.transparent,
      minimumSize: Size(buttonWidth, buttonHeight),
      elevation: 0,
      animationDuration: Duration(milliseconds: 60),
    );

    return ElevatedButton(
      child: text == "←"
          ? Icon(
              Icons.backspace,
              color: iconColor,
            )
          : Text(
              text ?? '',
              style: style,
            ),
      style: raisedButtonStyle,
      onPressed: onPressed,
      onLongPress: onLongPress,
    );
  }
}