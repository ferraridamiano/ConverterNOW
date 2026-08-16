import 'package:converterpro/app_router.dart';
import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:translations/app_localizations.dart';

class HideUnitsPage extends ConsumerStatefulWidget {
  /// The property whose units the user is hiding
  final PROPERTYX property;

  const HideUnitsPage(this.property, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HideUnitsPageState();
}

class _HideUnitsPageState extends ConsumerState<HideUnitsPage> {
  List unselectedUnits = [];

  @override
  void initState() {
    super.initState();
    initProvider();
  }

  @override
  void didUpdateWidget(covariant HideUnitsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initProvider();
  }

  void initProvider() {
    unselectedUnits = ref
        .read(HiddenUnitsNotifier.provider)
        .value![widget.property]!;
  }

  @override
  Widget build(BuildContext context) {
    // if we remove the following check, if you enter the site directly to
    // '/hide-units/:property' an error will occur
    if (!ref.watch(isEverythingLoadedProvider)) {
      return const SplashScreenWidget();
    }

    final l10n = AppLocalizations.of(context)!;

    final unitsNames = getUnitUiMap(context)[widget.property]!;
    final conversionOrderUnits = ref
        .watch(UnitsOrderNotifier.provider)
        .value![widget.property]!;
    final areAllSelected = unselectedUnits.isEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('confirm'),
        tooltip: l10n.save,
        child: const Icon(Icons.check),
        onPressed: () {
          ref
              .read(HiddenUnitsNotifier.provider.notifier)
              .set(unselectedUnits, widget.property);
          context.go('/conversions/${widget.property.toKebabCase()}');
        },
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(
            title: Text(
              l10n.visibleUnits(
                getPropertyUiMap(context)[widget.property]!.name,
              ),
            ),
            leading: BackButton(
              onPressed: () =>
                  context.go('/conversions/${widget.property.toKebabCase()}'),
            ),
            actions: [
              TextButton.icon(
                label: Text(areAllSelected ? l10n.unselectAll : l10n.selectAll),
                onPressed: () {
                  setState(() {
                    unselectedUnits = areAllSelected
                        ? defaultUnitsOrder[widget.property]!.toList(
                            growable: true,
                          )
                        : [];
                  });
                },
                icon: Icon(
                  areAllSelected
                      ? Icons.check_box_outline_blank
                      : Icons.check_box,
                ),
              ),
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
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
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
        ],
      ),
    );
  }
}
