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

  static const BorderRadiusGeometry borderRadius =
      BorderRadius.horizontal(right: Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).primaryColor.withOpacity(0.25)
              : Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: ListTile(
          leading: leading,
          title: title,
          onTap: onTap,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ),
    );
  }
}

class BigTitle extends StatelessWidget {
  const BigTitle({
    required this.text,
    this.subtitle = '',
    this.isSubtitleLoading = false,
    this.sidePadding = 0,
    this.center = false,
    Key? key,
  }) : super(key: key);
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
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFDDDDDD)
            : const Color(0xFF666666),
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
            height: 20,
            alignment: Alignment.bottomRight,
            child: (isSubtitleLoading && subtitle != '')
                ? Container(
                    padding: const EdgeInsets.only(right: 10),
                    height: 15.0,
                    width: 25.0,
                    child: const CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}

class UnitCard extends StatelessWidget {
  const UnitCard({required this.symbol, required this.textField, Key? key})
      : super(key: key);

  final String? symbol;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 14.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: textField,
            ),
          ),
        ),
        if (symbol != null)
          Align(
            alignment: const AlignmentDirectional(0.95, -0.9),
            child: Card(
              elevation: 4.0,
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  symbol!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
  SearchUnit(
      {required this.iconAsset, required this.unitName, required this.onTap});
}

class SearchUnitTile extends StatelessWidget {
  final SearchUnit searchUnit;
  final bool darkMode;
  const SearchUnitTile(this.searchUnit, this.darkMode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(searchUnit.iconAsset,
          height: 26.0, color: darkMode ? Colors.white : Colors.grey),
      title: Text(searchUnit.unitName),
      onTap: searchUnit.onTap,
    );
  }
}

class SuggestionList extends StatelessWidget {
  final List<SearchUnit> suggestions;
  final bool darkMode;
  const SuggestionList(
      {required this.suggestions, required this.darkMode, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < suggestions.length; i++)
          SearchUnitTile(suggestions[i], darkMode)
      ],
    );
  }
}

class SearchGridTile extends StatelessWidget {
  final String iconAsset;
  final String footer;
  final GestureTapCallback onTap;
  final bool darkMode;
  const SearchGridTile({
    required this.iconAsset,
    required this.footer,
    required this.onTap,
    required this.darkMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: GridTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 55.0,
                height: 55.0,
                child: Image.asset(
                  iconAsset,
                  color: darkMode ? Colors.white : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                footer,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18.0),
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

  /// This widget will return a [ListTile] with a dialog on mobile device and a
  /// [ListTile] with a [DropdownButton] for desktop device.
  const DropdownListTile({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.textStyle,
    Key? key,
  }) : super(key: key);

  static const BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        String selected = value;
        return ListTile(
          title: Text(
            title,
            style: textStyle,
          ),
          subtitle: Text(value),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
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
      default:
        return ListTile(
          title: Text(
            title,
            style: textStyle,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          trailing: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((String item) {
                return SizedBox(
                  width: 150,
                  child: Align(
                    alignment: Directionality.of(context) == TextDirection.ltr
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      value,
                      style: textStyle,
                    ),
                  ),
                );
              }).toList();
            },
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item.toString(),
                  style: textStyle,
                ),
              );
            }).toList(),
          ),
        );
    }
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('resources/images/logo.png', width: 150)),
    );
  }
}

/// This widget limits the size of the [child] (e.g. a ListTile) to [maxWidth]
/// and centers the content
class ConstrainedContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ConstrainedContainer(this.child, {this.maxWidth = 800, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
