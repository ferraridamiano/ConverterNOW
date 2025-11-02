import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:translations/app_localizations.dart';

class CustomSearchDelegate extends SearchDelegate<PROPERTYX?> {
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
    final List<SearchUnit> dataSearch = getSearchUnitsList((PROPERTYX result) {
      close(context, result);
    }, context);
    final List<PropertyGridTile> allConversions = getPropertyGridTiles(
      (PROPERTYX result) {
        close(context, result);
      },
      context,
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
    void Function(PROPERTYX) onTap, BuildContext context) {
  List<SearchUnit> searchUnitsList = [];
  final propertyUiMap = getPropertyUiMap(context);
  final unitUiMap = getUnitUiMap(context);

  for (final property in propertyUiMap.entries) {
    final propertyx = property.key;
    final propertyUi = property.value;
    final propertyImagePath = property.value.icon;
    // Add properties in search
    searchUnitsList.add(SearchUnit(
      iconAsset: propertyImagePath,
      unitName: propertyUi.name,
      onTap: () => onTap(property.key),
    ));
    // Add units in search
    searchUnitsList.addAll(
      unitUiMap[propertyx]!.values.map(
            (e) => SearchUnit(
              iconAsset: propertyImagePath,
              unitName: e,
              onTap: () => onTap(propertyx),
            ),
          ),
    );
  }

  return searchUnitsList;
}
