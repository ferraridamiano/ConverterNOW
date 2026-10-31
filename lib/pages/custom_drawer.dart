import 'package:converterpro/models/order.dart';
import 'package:converterpro/utils/navigator_utils.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:vector_graphics/vector_graphics.dart';

/// Whether the properties list in the drawer is in reorder mode.
final drawerPropertiesEditingProvider = StateProvider<bool>((ref) => false);

class CustomDrawer extends ConsumerWidget {
  final bool isDrawerFixed;
  final void Function() openCalculator;
  final void Function() openSearch;

  const CustomDrawer({
    required this.isDrawerFixed,
    required this.openCalculator,
    required this.openSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final Color iconColor = getIconColor(Theme.of(context));
    final bool isEditingProperties = ref.watch(drawerPropertiesEditingProvider);

    List<PROPERTYX>? propertiesOrdering = ref
        .watch(PropertiesOrderNotifier.provider)
        .value;

    if (propertiesOrdering == null) {
      return const SizedBox();
    }

    final propertyUiMap = getPropertyUiMap(context);

    Widget drawerTitle({required bool isEditing}) {
      const title = Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture(
                AssetBytesLoader('assets/app_icons_opti/logo.svg.vec'),
                width: 50,
                height: 50,
              ),
              Text(
                'Converter NOW',
                // Fixed independently of the accessibility settings. Already as
                // large as possible
                textScaler: TextScaler.noScaling,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.w300,
                  fontSize: 29,
                ),
              ),
            ],
          ),
        ),
      );
      return ExcludeSemantics(
        child: isDrawerFixed && !isEditing
            ? InkWell(onTap: () => context.go('/'), child: title)
            : title,
      );
    }

    Widget propertiesSectionHeader({required bool isEditing}) {
      final smallTitleColor = switch (Theme.brightnessOf(context)) {
        Brightness.light => Theme.of(context).primaryColor,
        Brightness.dark => HSLColor.fromColor(
          Theme.of(context).primaryColor,
        ).withLightness(0.7).toColor(),
      };
      return Padding(
        padding: const EdgeInsetsDirectional.only(start: 28, end: 12, top: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                isEditing ? l10n.reorder : l10n.conversions,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: smallTitleColor),
              ),
            ),
            IconButton(
              key: ValueKey(
                isEditing ? 'drawerSaveProperties' : 'drawerEditProperties',
              ),
              tooltip: isEditing ? l10n.save : l10n.reorderProperties,
              icon: Icon(isEditing ? Icons.check : Icons.edit_outlined),
              color: smallTitleColor,
              onPressed: () {
                ref.read(drawerPropertiesEditingProvider.notifier).state =
                    !isEditing;
              },
            ),
          ],
        ),
      );
    }

    if (isEditingProperties) {
      return Drawer(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              drawerTitle(isEditing: true),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(),
              ),
              propertiesSectionHeader(isEditing: true),
              Expanded(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom,
                  ),
                  itemCount: propertiesOrdering.length,
                  onReorderItem: (int oldIndex, int newIndex) =>
                      _reorderProperties(
                        ref,
                        propertiesOrdering,
                        propertyUiMap,
                        oldIndex,
                        newIndex,
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    final PROPERTYX property = propertiesOrdering[index];
                    final PropertyUi propertyUi = propertyUiMap[property]!;
                    return ListTile(
                      key: ValueKey('drawerReorderItem_$property'),
                      contentPadding: const EdgeInsetsDirectional.only(
                        start: 28,
                        end: 12,
                      ),
                      horizontalTitleGap: 12,
                      leading: SvgPicture(
                        AssetBytesLoader(propertyUi.icon),
                        width: 25,
                        height: 25,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      title: Text(propertyUi.name),
                      trailing: ReorderableDragStartListener(
                        key: ValueKey('drawerReorderHandle_$property'),
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> headerDrawer = <Widget>[drawerTitle(isEditing: false)];

    if (isDrawerFixed) {
      final keyDecoration = BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
        borderRadius: BorderRadius.circular(6),
      );
      const keyPadding = EdgeInsets.symmetric(horizontal: 4);
      headerDrawer.add(
        NavigationDrawerDestination(
          key: const ValueKey('drawerItem_search'),
          icon: Icon(Icons.search_outlined, color: iconColor),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(l10n.search),
              const SizedBox(width: 16),
              Container(
                decoration: keyDecoration,
                child: const Padding(padding: keyPadding, child: Text('Ctrl')),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text('+'),
              ),
              Container(
                decoration: keyDecoration,
                child: const Padding(padding: keyPadding, child: Text('K')),
              ),
            ],
          ),
        ),
      );
      headerDrawer.add(
        NavigationDrawerDestination(
          key: const ValueKey('drawerItem_calculator'),
          icon: Icon(Icons.calculate_outlined, color: iconColor),
          label: Text(l10n.calculator),
        ),
      );
    }
    headerDrawer.add(
      NavigationDrawerDestination(
        key: const ValueKey('drawerItem_settings'),
        icon: Icon(Icons.settings_outlined, color: iconColor),
        selectedIcon: Icon(Icons.settings, color: iconColor),
        label: Text(l10n.settings),
      ),
    );
    headerDrawer.add(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Divider(),
      ),
    );

    final propertiesDrawer = propertiesOrdering.map((e) {
      final propertyUi = propertyUiMap[e]!;
      return NavigationDrawerDestination(
        key: ValueKey('drawerItem_$e'),
        icon: SvgPicture(
          AssetBytesLoader(propertyUi.icon),
          width: 25,
          height: 25,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        selectedIcon: SvgPicture(
          AssetBytesLoader(propertyUi.selectedIcon),
          width: 25,
          height: 25,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        label: Text(propertyUi.name),
      );
    });

    // How many NavigationDrawerDestination elements are there in the drawer
    int headerElements = headerDrawer
        .whereType<NavigationDrawerDestination>()
        .toList()
        .length;

    void openSettings() {
      if (computeSelectedSection(context) == AppPage.settings) {
        context.goNamed('settings');
      } else {
        // Push instead of go so that going back pops Settings and animates the
        // transition back to the conversion page.
        context.pushNamed('settings');
      }
    }

    return NavigationDrawer(
      selectedIndex: pathToNavigationIndex(
        context,
        isDrawerFixed,
        propertiesOrdering.inverse(),
      ),
      onDestinationSelected: (int selectedPage) {
        if (selectedPage >= headerElements) {
          context.go(
            '/conversions/${propertiesOrdering[selectedPage - headerElements].toKebabCase()}',
          );
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
        } else if (headerElements == 3) {
          switch (selectedPage) {
            case 0:
              openSearch();
            case 1:
              openCalculator();
            case 2:
              if (!isDrawerFixed) {
                Navigator.of(context).pop();
              }
              openSettings();
          }
        } else if (headerElements == 1) {
          if (!isDrawerFixed) {
            Navigator.of(context).pop();
          }
          openSettings();
        }
      },
      children: <Widget>[
        ...headerDrawer,
        propertiesSectionHeader(isEditing: false),
        ...propertiesDrawer,
      ],
    );
  }

  /// Moves the property at [oldIndex] to [newIndex] and saves the new order.
  ///
  /// With [ReorderableListView.onReorderItem] the [newIndex] is already the
  /// final index of the item, so no adjustment is needed.
  void _reorderProperties(
    WidgetRef ref,
    List<PROPERTYX> currentOrder,
    Map<PROPERTYX, PropertyUi> propertyUiMap,
    int oldIndex,
    int newIndex,
  ) {
    if (oldIndex == newIndex) {
      return;
    }

    final List<PROPERTYX> reordered = <PROPERTYX>[...currentOrder];
    reordered.insert(newIndex, reordered.removeAt(oldIndex));

    final bool success = ref
        .read(PropertiesOrderNotifier.provider.notifier)
        .set(reordered.map(currentOrder.indexOf).toList());
    if (!success) {
      return;
    }

    updateQuickActionItems(
      conversionsOrderDrawer: reordered,
      propertyUiMap: propertyUiMap,
    );
    HapticFeedback.selectionClick();
  }
}

int? pathToNavigationIndex(
  BuildContext context,
  bool isDrawerFixed,
  Map<PROPERTYX, int> inversePropertiesOrdering,
) {
  final String location = GoRouterState.of(context).uri.toString();

  // 3 elements in the header
  if (isDrawerFixed) {
    if (location.startsWith('/conversions/')) {
      final int? index = computeSelectedConversionPage(
        context,
        inversePropertiesOrdering,
      );
      return index == null ? null : index + 3;
    } else {
      return 2; // Settings
    }
  }
  // 1 element in the header
  else {
    if (location.startsWith('/conversions/')) {
      final int? index = computeSelectedConversionPage(
        context,
        inversePropertiesOrdering,
      );
      return index == null ? null : index + 1;
    } else {
      return 0; // Settings
    }
  }
}
