import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';

class ChoosePropertyPage extends ConsumerWidget {
  const ChoosePropertyPage({
    super.key,
    this.selectedProperty,
    this.onSelectedProperty,
  });

  final PROPERTYX? selectedProperty;
  final void Function(PROPERTYX property)? onSelectedProperty;

  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesOrder =
        ref.watch(PropertiesOrderNotifier.provider).valueOrNull!;
    final propertyUiMap = getPropertyUiMap(context);
    final propertiesStringOrdered =
        propertiesOrder.map((e) => propertyUiMap[e]!.name).toList();

    Color selectedListTileColor = Theme.of(context)
        .colorScheme
        .primaryContainer
        .withValues(
          alpha: Theme.of(context).brightness == Brightness.light ? 0.5 : 0.8,
        );

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar.large(
          title: Text(AppLocalizations.of(context)!.chooseProperty),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: propertiesStringOrdered.length,
            (context, index) {
              final isSelectedProperty =
                  propertiesOrder[index] == selectedProperty;
              return Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: const Offset(0.0, 0.0),
                      ).animate(animation),
                      child: child,
                    ),
                    child: Padding(
                      key: Key(
                          '${propertiesStringOrdered[index]}-$isSelectedProperty'),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: isSelectedProperty
                            ? BoxDecoration(
                                color: selectedListTileColor,
                                borderRadius: borderRadius,
                              )
                            : null,
                        child: const ListTile(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: ListTile(
                        key: ValueKey(
                            'chooseProperty-${propertiesOrder[index]}'),
                        title: Text(
                          propertiesStringOrdered[index],
                          style: TextStyle(
                            fontSize: singlePageTextSize,
                            color: isSelectedProperty
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius: borderRadius),
                        onTap: onSelectedProperty == null
                            ? null
                            : () => onSelectedProperty!(propertiesOrder[index]),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
