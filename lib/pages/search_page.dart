import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:translations/app_localizations.dart';

class CustomSearchDelegate extends SearchDelegate<(PROPERTYX, String?)?> {
  final List<PROPERTYX> orderList;

  CustomSearchDelegate(this.orderList);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context)!.back,
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
    final Brightness brightness = Theme.of(context).brightness;

    final List<SearchUnit> dataSearch =
        getSearchUnitsList((PROPERTYX property, String? unitName) {
      close(context, (property, unitName));
    }, context);
    final List<SearchGridTile> allConversions = initializeGridSearch(
      (PROPERTYX property) {
        close(context, (property, null));
      },
      context,
      brightness == Brightness.dark,
      orderList,
    );

    final Iterable<SearchUnit> suggestions = dataSearch.where((searchUnit) =>
        searchUnit.unitName.toLowerCase().contains(query.toLowerCase()));
    //.toLowercase in order to be case insesitive

    return query.isNotEmpty
        ? SuggestionList(suggestions: suggestions.toList())
        : GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180.0,
            ),
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

/// This method will return a List of [SearchUnit], needed in order to display the tiles in the search
List<SearchUnit> getSearchUnitsList(
    void Function(PROPERTYX, String?) onTap, BuildContext context) {
  List<SearchUnit> searchUnitsList = [];
  final propertyUiMap = getPropertyUiMap(context);
  final unitUiMap = getUnitUiMap(context);

  for (final property in propertyUiMap.entries) {
    final propertyx = property.key;
    final propertyUi = property.value;
    final propertyImagePath = property.value.imagePath;
    // Add properties in search
    searchUnitsList.add(SearchUnit(
      iconAsset: propertyImagePath,
      unitName: propertyUi.name,
      onTap: () => onTap(property.key, null),
    ));
    // Add units in search
    searchUnitsList.addAll(
      unitUiMap[propertyx]!.entries.map(
            (e) => SearchUnit(
              iconAsset: propertyImagePath,
              unitName: e.value,
              onTap: () => onTap(propertyx, unitName2KebabCase(e.key)),
            ),
          ),
    );
  }

  return searchUnitsList;
}

/// This method will return a List of [SearchGridTile], needed in order to display the gridtiles in the search
List<SearchGridTile> initializeGridSearch(void Function(PROPERTYX) onTap,
    BuildContext context, bool darkMode, List<PROPERTYX> orderList) {
  final propertyUiMap = getPropertyUiMap(context);
  return orderList.map((e) {
    final propertyUi = propertyUiMap[e]!;
    return SearchGridTile(
      iconAsset: propertyUi.imagePath,
      footer: propertyUi.name,
      onTap: () => onTap(e),
      darkMode: darkMode,
    );
  }).toList();
}
