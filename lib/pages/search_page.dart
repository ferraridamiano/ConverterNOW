import 'package:converterpro/utils/property_unit_list.dart';
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
    final Brightness brightness = Theme.of(context).brightness;

    final List<SearchUnit> dataSearch = getSearchUnitsList((PROPERTYX result) {
      close(context, result);
    }, context);
    final List<SearchGridTile> allConversions = initializeGridSearch(
      (PROPERTYX result) {
        close(context, result);
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
