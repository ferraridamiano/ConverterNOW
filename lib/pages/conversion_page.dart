import 'dart:async';

import 'package:converterpro/app_router.dart';
import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translations/app_localizations.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/models/order.dart';
import 'package:intl/intl.dart';
import 'package:flutter_reorderable_grid_view/entities/reorderable_animation_config.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// True while a forced currencies download triggered by tapping the last
/// update date is in progress (used to show a progress indicator).
final _isCurrenciesUpdatingProvider = StateProvider<bool>((ref) => false);

class ConversionPage extends ConsumerWidget {
  final PROPERTYX property;

  /// The unit (e.g. 'atmospheres') selected from the search page, that will
  /// be scrolled to and highlighted. Null when the page is opened normally.
  final String? targetUnit;

  const ConversionPage(this.property, {this.targetUnit, super.key});

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

    // The unit selected from the search page (query parameter 'unit'), if it
    // belongs to this property. The parameter carries only the unit
    // identifier (e.g. 'atmospheres' or 'USD'), which is unique within the
    // property. Currencies are identified by a plain string, all other units
    // by an enum.
    UnitData? targetUnitData;
    if (targetUnit != null) {
      for (final unitData in unitDataList) {
        final dynamic unitName = unitData.unit.name;
        final bool matches = unitName is Enum
            ? unitName.name == targetUnit
            : unitName.toString() == targetUnit;
        if (matches) {
          targetUnitData = unitData;
          break;
        }
      }
    }

    Widget? subtitleWidget;
    if (property == PROPERTYX.currencies) {
      Currencies? currencies = ref.watch(CurrenciesNotifier.provider).value;
      final isUpdating = ref.watch(_isCurrenciesUpdatingProvider);
      subtitleWidget = currencies == null || isUpdating
          ? const SizedBox(
              height: 32,
              width: 32,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(),
              ),
            )
          : FilledButton.tonal(
              onPressed: () => _forceCurrenciesUpdate(context, ref),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Text(
                    _getLastUpdateString(
                      context,
                      ref.watch(actualLocaleProvider)!,
                      currencies.lastUpdate,
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (currencies.downloadError != null)
                    Icon(
                      Icons.error_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.error,
                    ),
                ],
              ),
            );
    }

    UnitWidget unitWidgetBuilder(
      UnitData unitData, {
      Widget? dragHandle,
      bool isHidden = false,
    }) => UnitWidget(
      // When this is the unit selected from the search page, the [ValueKey]
      // is moved onto the wrapping [_TargetUnitReveal], so that the reorder
      // package still sees a [ValueKey] on the direct child.
      key: identical(unitData, targetUnitData)
          ? null
          : ValueKey('unit-${unitData.unit.name}'),
      tffKey: unitData.unit.name.toString(),
      unitName: unitMap[unitData.unit.name]!,
      unitSymbol: unitData.unit.symbol,
      symbolContainsIcon: unitData.property == PROPERTYX.currencies,
      keyboardType: unitData.textInputType,
      controller: unitData.tec,
      focusNode: unitData.fn,
      dragHandle: dragHandle,
      visibilityHandle: IconButton(
        tooltip: isHidden ? l10n.showUnit : l10n.hideUnit,
        icon: Icon(
          isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          unitData.fn.unfocus();
          ref
              .read(HiddenUnitsNotifier.provider.notifier)
              .set(
                isHidden
                    ? hiddenUnits.where((e) => e != unitData.unit.name).toList()
                    : [...hiddenUnits, unitData.unit.name],
                property,
              );
        },
      ),
      validator: (String? input) {
        if (input != null && input != '') {
          final decimalSeparator = ref.read(decimalSeparatorProvider);
          final normalizedInput = input.replaceAll(decimalSeparator, '.');
          if (!unitData.getValidator().hasMatch(normalizedInput)) {
            return l10n.invalidCharacters;
          }
        }
        return null;
      },
      onChanged: (String txt) {
        String newTxt = txt;
        bool changed = false;
        final decimalSeparator = ref.read(decimalSeparatorProvider);

        for (final separator in ['.', ',']) {
          if (newTxt.contains(separator) && decimalSeparator != separator) {
            newTxt = newTxt.replaceAll(separator, decimalSeparator);
            changed = true;
          }
        }
        if (newTxt.startsWith(decimalSeparator)) {
          newTxt = '0$newTxt';
          changed = true;
        }
        if (changed) {
          unitData.tec.value = TextEditingValue(
            text: newTxt,
            selection: TextSelection.collapsed(offset: newTxt.length),
          );
        }
        final normalizedTxt = newTxt.replaceAll(decimalSeparator, '.');
        if (newTxt == '' || unitData.getValidator().hasMatch(normalizedTxt)) {
          var conversions = ref.read(ConversionsNotifier.provider.notifier);
          //just numeral system uses a string for conversion
          if (unitData.property == PROPERTYX.numeralSystems) {
            conversions.convert(
              unitData,
              newTxt == "" ? null : newTxt,
              property,
            );
          } else {
            conversions.convert(
              unitData,
              newTxt == "" ? null : double.parse(normalizedTxt),
              property,
            );
          }
        }
      },
    );

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
                    child: ReorderableBuilder.builder(
                      // No fade-in animation when the page is loaded.
                      animationConfig: const ReorderableAnimationConfig(
                        fadeInDuration: Duration.zero,
                      ),
                      // No shadow on the unit tile while it is dragged.
                      dragChildBoxDecoration: const BoxDecoration(),
                      onReorderPositions: (reorderUpdateEntities) {
                        for (final entity in reorderUpdateEntities) {
                          ref
                              .read(UnitsOrderNotifier.provider.notifier)
                              .reorderUnhidden(
                                entity.oldIndex,
                                entity.newIndex,
                                property,
                                hiddenUnits,
                              );
                        }
                      },
                      itemCount: unhiddenUnitData.length,
                      childBuilder: (itemBuilder) => GridView.builder(
                        key: GlobalObjectKey(property),
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
                        itemBuilder: (context, index) {
                          final unitData = unhiddenUnitData[index];
                          final unitWidget = unitWidgetBuilder(
                            unitData,
                            dragHandle: GestureDetector(
                              // The reorder starts with a long press: if the
                              // handle is only tapped, explain it to the user.
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.longPressAdvice),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(
                                        milliseconds: 1000,
                                      ),
                                    ),
                                  );
                              },
                              child: const Icon(Icons.drag_handle),
                            ),
                          );
                          return itemBuilder(
                            identical(unitData, targetUnitData)
                                ? _TargetUnitReveal(
                                    key: ValueKey('unit-${unitData.unit.name}'),
                                    isHidden: false,
                                    child: unitWidget,
                                  )
                                : unitWidget,
                            index,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (hiddenUnitData.isNotEmpty)
                  SliverToBoxAdapter(
                    child: ExpansionTile(
                      // Keep the hidden units in the tree even when the tile
                      // is collapsed: this way the unit selected from the
                      // search page can expand the tile and scroll to itself.
                      maintainState: true,
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
                          itemBuilder: (context, index) {
                            final unitData = hiddenUnitData[index];
                            final unitWidget = unitWidgetBuilder(
                              unitData,
                              isHidden: true,
                            );
                            return identical(unitData, targetUnitData)
                                ? _TargetUnitReveal(
                                    key: ValueKey('unit-${unitData.unit.name}'),
                                    isHidden: true,
                                    child: unitWidget,
                                  )
                                : unitWidget;
                          },
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

String _getLastUpdateString(
  BuildContext context,
  Locale locale,
  String lastUpdate,
) {
  final l10n = AppLocalizations.of(context)!;
  DateTime lastUpdateCurrencies = DateTime.parse(lastUpdate);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day &&
      lastUpdateCurrencies.month == dateNow.month &&
      lastUpdateCurrencies.year == dateNow.year) {
    return l10n.lastCurrenciesUpdate + l10n.today.toLowerCase();
  }
  return l10n.lastCurrenciesUpdate +
      DateFormat.yMd(locale.toString()).format(lastUpdateCurrencies);
}

Future<void> _forceCurrenciesUpdate(BuildContext context, WidgetRef ref) async {
  final updatingNotifier = ref.read(_isCurrenciesUpdatingProvider.notifier);
  updatingNotifier.state = true;
  try {
    await ref
        .read(CurrenciesNotifier.provider.notifier)
        .forceCurrenciesDownload();
  } finally {
    updatingNotifier.state = false;
  }
  if (!context.mounted) return;
  final error = ref.read(CurrenciesNotifier.provider).value?.downloadError;
  if (error != null) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

/// Wraps the unit selected from the search page: when it first appears, it
/// scrolls the unit into view (expanding the hidden units tile if needed) and
/// briefly highlights it.
class _TargetUnitReveal extends StatefulWidget {
  final Widget child;

  /// Whether the wrapped unit is inside the hidden units [ExpansionTile].
  final bool isHidden;

  const _TargetUnitReveal({
    required this.child,
    required this.isHidden,
    super.key,
  });

  @override
  State<_TargetUnitReveal> createState() => _TargetUnitRevealState();
}

class _TargetUnitRevealState extends State<_TargetUnitReveal> {
  final GlobalKey _unitKey = GlobalKey();
  bool _highlighted = false;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    super.dispose();
  }

  Future<void> _reveal() async {
    if (widget.isHidden) {
      // The unit is inside the hidden units ExpansionTile: expand it so that
      // the unit is actually visible when scrolled to. The controller is the
      // one automatically created by the tile, reachable because this widget
      // is below it in the tree.
      final ExpansibleController? controller = ExpansibleController.maybeOf(
        context,
      );
      if (controller != null && !controller.isExpanded) {
        controller.expand();
        // Wait for the expansion animation to complete, so that the position
        // of the unit inside the tile is final before scrolling to it.
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    }
    if (!mounted) return;
    final BuildContext? unitContext = _unitKey.currentContext;
    if (unitContext == null || !unitContext.mounted) return;
    await Scrollable.ensureVisible(
      unitContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.2,
    );
    if (!mounted) return;
    setState(() => _highlighted = true);
    _highlightTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _highlighted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _unitKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _highlighted
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: widget.child,
      ),
    );
  }
}
