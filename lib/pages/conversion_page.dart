import 'package:converterpro/app_router.dart';
import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translations/app_localizations.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:intl/intl.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:go_router/go_router.dart';

class ConversionPage extends ConsumerWidget {
  final PROPERTYX property;

  const ConversionPage(this.property, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if we remove the following check, if you enter the site directly to
    // '/conversions/:property' an error will occur
    if (!ref.watch(isEverythingLoadedProvider)) {
      return const SplashScreenWidget();
    }

    final l10n = AppLocalizations.of(context)!;

    final heroEnabled = ref.watch(conversionPageHeroEnabledProvider);

    final unitDataList = ref
        .watch(ConversionsNotifier.provider)
        .value![property]!;
    final propertyUiMap = getPropertyUiMap(context);
    final unitMap = getUnitUiMap(context)[property]!;
    final hiddenUnits = ref
        .watch(HiddenUnitsNotifier.provider)
        .value![property]!;
    final hiddenUnitData = unitDataList
        .where((e) => hiddenUnits.contains(e.unit.name))
        .toList();
    final unhiddenUnitData = unitDataList
        .where((e) => !hiddenUnits.contains(e.unit.name))
        .toList();

    Widget? subtitleWidget;
    if (property == PROPERTYX.currencies) {
      Currencies? currencies = ref.watch(CurrenciesNotifier.provider).value;
      if (currencies == null) {
        subtitleWidget = const SizedBox(
          height: 30,
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      } else {
        subtitleWidget = Text(
          _getLastUpdateString(context, currencies.lastUpdate),
          style: Theme.of(context).textTheme.titleSmall,
        );
      }
    }

    UnitWidget unitWidgetBuilder(
      UnitData unitData, {
      bool isReorderable = false,
    }) => UnitWidget(
      tffKey: unitData.unit.name.toString(),
      unitName: unitMap[unitData.unit.name]!,
      unitSymbol: unitData.unit.symbol,
      symbolContainsIcon: unitData.property == PROPERTYX.currencies,
      keyboardType: unitData.textInputType,
      controller: unitData.tec,
      showReorderHandle: isReorderable,
      validator: (String? input) {
        if (input != null) {
          if (input != '' && !unitData.getValidator().hasMatch(input)) {
            return l10n.invalidCharacters;
          }
        }
        return null;
      },
      onChanged: (String txt) {
        String newTxt = txt;
        bool changed = false;
        if (newTxt.contains(',')) {
          newTxt = newTxt.replaceAll(',', '.');
          changed = true;
        }
        if (newTxt.startsWith('.')) {
          newTxt = '0$newTxt';
          changed = true;
        }
        if (changed) {
          unitData.tec.value = TextEditingValue(
            text: newTxt,
            selection: TextSelection.collapsed(offset: newTxt.length),
          );
        }
        if (txt == '' || unitData.getValidator().hasMatch(txt)) {
          var conversions = ref.read(ConversionsNotifier.provider.notifier);
          //just numeral system uses a string for conversion
          if (unitData.property == PROPERTYX.numeralSystems) {
            conversions.convert(unitData, txt == "" ? null : txt, property);
          } else {
            conversions.convert(
              unitData,
              txt == "" ? null : double.parse(txt),
              property,
            );
          }
        }
      },
    );

    // On desktop the drag starts immediately when pressing and moving a tile,
    // on mobile a long press is needed
    final bool isDesktop = switch (Theme.of(context).platform) {
      TargetPlatform.linux ||
      TargetPlatform.windows ||
      TargetPlatform.macOS => true,
      _ => false,
    };

    /// Saves the new order of the units after a drag and drop. Only the
    /// visible units are reordered, the hidden ones keep their position.
    void reorderUnits(
      List<UnitData> Function(List<UnitData>) reorderedListFunction,
    ) {
      final currentUnitDataList = ref
          .read(ConversionsNotifier.provider)
          .value![property]!;
      final hiddenUnitNames = ref
          .read(HiddenUnitsNotifier.provider)
          .value![property]!
          .toSet();
      final visibleUnitData = currentUnitDataList
          .where((e) => !hiddenUnitNames.contains(e.unit.name))
          .toList();
      final newVisibleOrder = reorderedListFunction(visibleUnitData);
      if (listEquals(newVisibleOrder, visibleUnitData)) {
        return;
      }
      // Rebuild the full order keeping the hidden units in their positions
      final iterator = newVisibleOrder.iterator;
      final newFullOrder = <UnitData>[];
      for (final unitData in currentUnitDataList) {
        if (hiddenUnitNames.contains(unitData.unit.name)) {
          newFullOrder.add(unitData);
        } else {
          iterator.moveNext();
          newFullOrder.add(iterator.current);
        }
      }
      // Convert the new order to indices and save it
      final currentUnitsOrder = ref
          .read(UnitsOrderNotifier.provider)
          .value![property]!;
      final newIndices = newFullOrder
          .map((unitData) => currentUnitsOrder.indexOf(unitData.unit.name))
          .toList();
      ref.read(UnitsOrderNotifier.provider.notifier).set(newIndices, property);
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: unitDataList[0].tec,
      builder: (context, textValue, child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint) {
            final int numCols = responsiveNumCols(constraint.maxWidth);
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar.large(
                  title: Builder(
                    builder: (context) {
                      final isExpanded =
                          (DefaultTextStyle.of(context).style.fontSize ??
                              22.0) >
                          24.0;
                      final iconWidget = SvgPicture(
                        AssetBytesLoader(propertyUiMap[property]!.selectedIcon),
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.titleLarge!.color!,
                          BlendMode.srcIn,
                        ),
                      );
                      final textWidget = Material(
                        type: MaterialType.transparency,
                        child: Text(
                          propertyUiMap[property]!.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      );
                      return Row(
                        spacing: 12,
                        children: [
                          isExpanded
                              ? HeroMode(
                                  enabled: heroEnabled,
                                  child: Hero(
                                    tag: 'icon-${property.toString()}',
                                    child: iconWidget,
                                  ),
                                )
                              : iconWidget,
                          isExpanded
                              ? HeroMode(
                                  enabled: heroEnabled,
                                  child: Hero(
                                    tag: 'text-${property.toString()}',
                                    child: textWidget,
                                  ),
                                )
                              : textWidget,
                        ],
                      );
                    },
                  ),
                  actions: [
                    MenuAnchor(
                      menuChildren: [
                        MenuItemButton(
                          key: const ValueKey('hide-units'),
                          leadingIcon: const Icon(
                            Icons.visibility_off_outlined,
                          ),
                          onPressed: () => context.go(
                            '/conversions/${property.toKebabCase()}/hide',
                          ),
                          child: Text(l10n.hideUnits),
                        ),
                      ],
                      builder: (context, controller, child) {
                        return IconButton(
                          key: const ValueKey('appbar-menu'),
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => controller.isOpen
                              ? controller.close()
                              : controller.open(),
                        );
                      },
                    ),
                  ],
                ),
                if (subtitleWidget != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [subtitleWidget],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10),
                  sliver: SliverToBoxAdapter(
                    child: ReorderableBuilder<UnitData>.builder(
                      longPressDelay: isDesktop
                          ? Duration.zero
                          : kLongPressTimeout,
                      dragChildBoxDecoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onReorder: reorderUnits,
                      itemCount: unhiddenUnitData.length,
                      childBuilder: (itemBuilder) => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numCols,
                          childAspectRatio: responsiveChildAspectRatio(
                            constraint.maxWidth,
                            numCols,
                          ),
                        ),
                        itemCount: unhiddenUnitData.length,
                        itemBuilder: (context, index) => itemBuilder(
                          KeyedSubtree(
                            key: ValueKey(
                              'unit-${unhiddenUnitData[index].unit.name}',
                            ),
                        child: _DragCue(
                          child: unitWidgetBuilder(
                            unhiddenUnitData[index],
                            isReorderable: true,
                          ),
                        ),
                          ),
                          index,
                        ),
                      ),
                    ),
                  ),
                ),
                if (hiddenUnitData.isNotEmpty)
                  SliverToBoxAdapter(
                    child: ExpansionTile(
                      leading: const Icon(Icons.visibility_off_outlined),
                      title: Text(
                        l10n.hiddenUnits,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: numCols,
                                childAspectRatio: responsiveChildAspectRatio(
                                  constraint.maxWidth,
                                  numCols,
                                ),
                              ),
                          itemCount: hiddenUnitData.length,
                          itemBuilder: (context, index) =>
                              unitWidgetBuilder(hiddenUnitData[index]),
                        ),
                      ],
                    ),
                  ),
                if (isDrawerFixed(MediaQuery.sizeOf(context).width) &&
                    MediaQuery.viewInsetsOf(context).bottom == 0 &&
                    textValue.text.isNotEmpty)
                  // Space for FAB + navigation bar (android)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 60 + MediaQuery.paddingOf(context).bottom,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Shows a subtle highlight and a grab cursor when the user hovers a unit
/// tile, to communicate that the tile can be dragged to be reordered.
class _DragCue extends StatefulWidget {
  final Widget child;

  const _DragCue({required this.child});

  @override
  State<_DragCue> createState() => _DragCueState();
}

class _DragCueState extends State<_DragCue> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                : Colors.transparent,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

String _getLastUpdateString(BuildContext context, String lastUpdate) {
  final l10n = AppLocalizations.of(context)!;
  DateTime lastUpdateCurrencies = DateTime.parse(lastUpdate);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day &&
      lastUpdateCurrencies.month == dateNow.month &&
      lastUpdateCurrencies.year == dateNow.year) {
    return l10n.lastCurrenciesUpdate + l10n.today.toLowerCase();
  }
  return l10n.lastCurrenciesUpdate +
      DateFormat.yMd(
        Localizations.localeOf(context).languageCode,
      ).format(lastUpdateCurrencies);
}
