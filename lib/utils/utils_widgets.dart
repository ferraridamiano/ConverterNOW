import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

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
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: selected
            ? BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(
                        Theme.of(context).brightness == Brightness.light
                            ? 0.5
                            : 0.8),
                borderRadius: borderRadius,
              )
            : null,
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

class UnitWidget extends StatefulWidget {
  final String tffKey;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String unitName;
  final String? unitSymbol;
  final void Function(String)? onChanged;

  const UnitWidget({
    Key? key,
    required this.tffKey,
    this.keyboardType,
    required this.controller,
    this.validator,
    required this.unitName,
    this.unitSymbol,
    this.onChanged,
  }) : super(key: key);

  @override
  State<UnitWidget> createState() => _UnitWidgetState();
}

class _UnitWidgetState extends State<UnitWidget> {
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() => setState(() {}));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: TextFormField(
        key: ValueKey(widget.tffKey),
        focusNode: focusNode,
        style: const TextStyle(fontSize: 16.0),
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.unitName,
          suffixIcon: widget.unitSymbol == null
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Text(widget.unitSymbol!),
                ),
          // Workaround to make suffixIcon always visible
          // See: https://stackoverflow.com/questions/58819979
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          floatingLabelStyle: TextStyle(
            fontSize: 20,
            color: focusNode.hasFocus
                ? Theme.of(context).colorScheme.secondary
                : null,
          ),
        ),
        onChanged: widget.onChanged,
      ),
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
      leading: SvgPicture(
        AssetBytesLoader(searchUnit.iconAsset),
        height: 26.0,
        colorFilter: ColorFilter.mode(
          darkMode ? Colors.white : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
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
                child: SvgPicture(
                  AssetBytesLoader(iconAsset),
                  colorFilter: ColorFilter.mode(
                    darkMode ? Colors.white : Colors.grey,
                    BlendMode.srcIn,
                  ),
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
  final Widget? leading;

  /// This widget will return a [ListTile] with a dialog on mobile device and a
  /// [ListTile] with a [DropdownMenu] for desktop device.
  const DropdownListTile({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.textStyle,
    this.leading,
    ValueKey? key,
  }) : super(key: key);

  static const BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        String selected = value;
        return ListTile(
          leading: leading,
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
          leading: leading,
          title: Text(
            title,
            style: textStyle,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          trailing: DropdownMenu<String>(
            key: key != null
                ? ValueKey('${(key as ValueKey).value}-dropdown')
                : null,
            initialSelection: value,
            onSelected: onChanged,
            width: 150,
            inputDecorationTheme: const InputDecorationTheme(
              outlineBorder: BorderSide.none,
            ),
            dropdownMenuEntries: items.map((String item) {
              return DropdownMenuEntry<String>(
                value: item,
                label: item.toString(),
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
    return const Scaffold(
      body: Center(
        child: SvgPicture(
          AssetBytesLoader('assets/app_icons/logo.svg.vec'),
          width: 150,
        ),
      ),
    );
  }
}

/// This widget limits the size of the [child] (e.g. a ListTile) to [maxWidth]
/// and centers the content
class ConstrainedContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ConstrainedContainer(this.child, {this.maxWidth = 500, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
