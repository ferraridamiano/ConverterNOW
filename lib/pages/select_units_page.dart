import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/app_localizations.dart';

class SelectUnitsPage extends ConsumerStatefulWidget {
  const SelectUnitsPage({super.key, required this.selectedProperty});

  final PROPERTYX selectedProperty;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectUnitsPageState();
}

class _SelectUnitsPageState extends ConsumerState<SelectUnitsPage> {
  List unselectedUnits = [];

  @override
  void initState() {
    super.initState();
    initProvider();
  }

  @override
  void didUpdateWidget(covariant SelectUnitsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initProvider();
  }

  void initProvider() {
    unselectedUnits = ref
        .read(HiddenUnitsNotifier.provider)
        .valueOrNull![widget.selectedProperty]!;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final unitsNames = getUnitUiMap(context)[widget.selectedProperty]!;
    final conversionOrderUnits =
        ref.watch(UnitsOrderNotifier.provider).value![widget.selectedProperty]!;
    final areAllSelected = unselectedUnits.isEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('confirm'),
        tooltip: l10n.save,
        child: const Icon(Icons.check),
        onPressed: () {
          ref
              .read(HiddenUnitsNotifier.provider.notifier)
              .set(unselectedUnits, widget.selectedProperty);
          context.goNamed('hide-units');
        },
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar.large(
          title: Text(
            l10n.visibleUnits(
                getPropertyUiMap(context)[widget.selectedProperty]!.name),
          ),
          actions: [
            TextButton.icon(
              label: Text(areAllSelected ? l10n.unselectAll : l10n.selectAll),
              onPressed: () {
                setState(() {
                  unselectedUnits = areAllSelected
                      ? defaultUnitsOrder[widget.selectedProperty]!
                          .toList(growable: true)
                      : [];
                });
              },
              icon: Icon(
                areAllSelected
                    ? Icons.check_box_outline_blank
                    : Icons.check_box,
              ),
            )
          ],
        ),
        SliverPadding(
          // Space for FAB + navigation bar (android)
          padding: EdgeInsets.only(
            bottom: 60 + MediaQuery.paddingOf(context).bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: conversionOrderUnits.length,
              (context, index) {
                final unitCodeName = conversionOrderUnits[index];
                return CheckboxListTile(
                  value: !unselectedUnits.contains(unitCodeName),
                  controlAffinity: ListTileControlAffinity.leading,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onChanged: (selected) {
                    if (selected == null) {
                      return;
                    }
                    setState(() {
                      if (selected) {
                        unselectedUnits.remove(unitCodeName);
                      } else {
                        unselectedUnits.add(unitCodeName);
                      }
                    });
                  },
                  title: Text(unitsNames[unitCodeName]!),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
