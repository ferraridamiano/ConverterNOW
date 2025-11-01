import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translations/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class UnitWidget extends StatefulWidget {
  final String tffKey;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String unitName;
  final String? unitSymbol;
  final void Function(String) onChanged;

  const UnitWidget({
    super.key,
    required this.tffKey,
    this.keyboardType,
    required this.controller,
    this.validator,
    required this.unitName,
    this.unitSymbol,
    required this.onChanged,
  });

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
          suffixIcon: focusNode.hasFocus && widget.controller.text.isNotEmpty
              ? IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.copy),
                  tooltip: AppLocalizations.of(context)?.copy,
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.controller.text),
                    );
                    HapticFeedback.heavyImpact();
                  },
                )
              : widget.unitSymbol == null
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
            color: Theme.brightnessOf(context) == Brightness.light
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
        onChanged: (text) {
          widget.onChanged(text);
          setState(() {});
        },
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
  const SearchUnitTile(this.searchUnit, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture(
        AssetBytesLoader(searchUnit.iconAsset),
        height: 26.0,
        colorFilter: ColorFilter.mode(
          getIconColor(Theme.of(context)),
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
  const SuggestionList({required this.suggestions, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < suggestions.length; i++)
          SearchUnitTile(suggestions[i])
      ],
    );
  }
}

class PropertyGridTile extends StatelessWidget {
  final String iconAsset;
  final String footer;
  final GestureTapCallback onTap;
  const PropertyGridTile({
    required this.iconAsset,
    required this.footer,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: SvgPicture(
              AssetBytesLoader(iconAsset),
              height: 55,
              colorFilter: ColorFilter.mode(
                Theme.brightnessOf(context) == Brightness.dark
                    ? Colors.white
                    : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              footer,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, height: 1.1),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownListTile extends StatelessWidget {
  final String title;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final Widget? leading;

  /// This widget will return a [ListTile] with a dialog on mobile device and a
  /// [ListTile] with a [DropdownMenu] for desktop device.
  const DropdownListTile({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    this.leading,
    ValueKey? key,
  }) : super(key: key);

  static const BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return switch (Theme.of(context).platform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia =>
        ListTile(
          leading: leading,
          title: Text(
            title,
          ),
          subtitle: Text(value),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          onTap: () async => onChanged(
            await showModalBottomRadioList(
              context: context,
              title: title,
              items: items,
              value: value,
            ),
          ),
        ),
      TargetPlatform.linux ||
      TargetPlatform.windows ||
      TargetPlatform.macOS =>
        ListTile(
          leading: leading,
          title: Text(
            title,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          trailing: DropdownMenu<String>(
            key: key != null
                ? ValueKey('${(key as ValueKey).value}-dropdown')
                : null,
            initialSelection: value,
            onSelected: onChanged,
            requestFocusOnTap: false,
            width: 170,
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
        )
    };
  }
}

class SegmentedButtonListTile extends StatelessWidget {
  final String title;
  final List<({IconData icon, String title})> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final Widget? leading;

  /// This widget will return a [ListTile] with a dialog on mobile device and a
  /// [ListTile] with a [DropdownMenu] for desktop device.
  const SegmentedButtonListTile({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    this.leading,
    ValueKey? key,
  }) : super(key: key);

  static const BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth > 450
          ? ListTile(
              leading: leading,
              title: Text(title),
              shape: const RoundedRectangleBorder(borderRadius: borderRadius),
              trailing: SegmentedButton<String>(
                segments: items
                    .map((e) => ButtonSegment<String>(
                          icon: Icon(e.icon),
                          value: e.title,
                          tooltip: e.title,
                        ))
                    .toList(),
                selected: {value},
                onSelectionChanged: (val) => onChanged(val.first),
              ),
            )
          : ListTile(
              leading: leading,
              title: Text(title),
              subtitle: Text(value),
              shape: const RoundedRectangleBorder(borderRadius: borderRadius),
              onTap: () async => onChanged(
                await showModalBottomRadioList(
                  context: context,
                  title: title,
                  items: items.map((e) => e.title).toList(),
                  value: value,
                ),
              ),
            ),
    );
  }
}

Future<String?> showModalBottomRadioList({
  required BuildContext context,
  required String title,
  required List<String> items,
  required String value,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 15),
          RadioGroup(
            groupValue: value,
            onChanged: (value) => Navigator.pop(context, value),
            child: Column(
              children: items
                  .map((item) => RadioListTile(
                        value: item,
                        title: Text(item),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    },
  );
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SvgPicture(
          AssetBytesLoader('assets/app_icons_opti/logo.svg.vec'),
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
  const ConstrainedContainer(this.child, {this.maxWidth = 600, super.key});

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

/// This method will return a List of [PropertyGridTile], needed in order to
/// display the gridtiles in the search
List<PropertyGridTile> getPropertyGridTiles(void Function(PROPERTYX) onTap,
    BuildContext context, List<PROPERTYX> orderList) {
  final propertyUiMap = getPropertyUiMap(context);
  return orderList.indexed.map((e) {
    final propertyUi = propertyUiMap[e.$2]!;
    return PropertyGridTile(
      key: ValueKey('gridtile-${e.$1}'),
      iconAsset: propertyUi.icon,
      footer: propertyUi.name,
      onTap: () => onTap(e.$2),
    );
  }).toList();
}
