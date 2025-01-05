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
  final tempUnselectedUnitsProvider = StateProvider<List>((ref) => []);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tempUnselectedUnitsProvider.notifier).state = ref
          .read(HiddenUnitsNotifier.provider)
          .valueOrNull![widget.selectedProperty]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unitsNames = getUnitUiMap(context)[widget.selectedProperty]!;
    final conversionOrderUnits =
        ref.watch(UnitsOrderNotifier.provider).value![widget.selectedProperty]!;
    final unselectedUnits = ref.watch(tempUnselectedUnitsProvider);
    final areAllSelected = unselectedUnits.isEmpty;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('confirm'),
        tooltip: AppLocalizations.of(context)!.save,
        child: const Icon(Icons.check),
        onPressed: () {
          ref
              .read(HiddenUnitsNotifier.provider.notifier)
              .set(unselectedUnits, widget.selectedProperty);
          context.goNamed('settings');
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
                if (areAllSelected) {
                  ref.read(tempUnselectedUnitsProvider.notifier).state =
                      defaultUnitsOrder[widget.selectedProperty]!;
                } else {
                  ref.read(tempUnselectedUnitsProvider.notifier).state = [];
                }
              },
              icon: Icon(
                areAllSelected
                    ? Icons.check_box_outline_blank
                    : Icons.check_box,
              ),
            )
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: conversionOrderUnits.length,
            (context, index) {
              final unitCodeName = conversionOrderUnits[index];
              return CheckboxListTile(
                value: !unselectedUnits.contains(unitCodeName),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (selected) {
                  if (selected == null) {
                    return;
                  }
                  final newState = [...unselectedUnits];
                  if (selected) {
                    newState.remove(unitCodeName);
                  } else {
                    newState.add(unitCodeName);
                  }
                  ref.read(tempUnselectedUnitsProvider.notifier).state =
                      newState;
                },
                title: Text(unitsNames[unitCodeName]!),
              );
            },
          ),
        )
      ]),
    );
  }
}
