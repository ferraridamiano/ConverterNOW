import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:calculator_widget/calculator_widget.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/pages/custom_drawer.dart';
import 'package:converterpro/pages/search_page.dart';
import 'package:converterpro/utils/navigator_utils.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    void openCalculator() {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const CalculatorWidget();
        },
      );
    }

    void clearAll(bool isDrawerFixed) {
      final currentProperty = kebabStringToPropertyX(GoRouterState.of(context)
          .uri
          .toString()
          .substring('/conversions/'.length));
      if (ref
          .read(ConversionsNotifier.provider.notifier)
          .shouldShowSnackbar(currentProperty)) {
        ref
            .read(ConversionsNotifier.provider.notifier)
            .clearAllValues(currentProperty);
        //Snackbar undo request
        final SnackBar snackBar = SnackBar(
          content: Text(l10n.undoClearAllMessage),
          behavior: SnackBarBehavior.floating,
          width: isDrawerFixed ? 400 : null,
          action: SnackBarAction(
            key: const ValueKey('undoClearAll'),
            label: l10n.undo,
            onPressed: () {
              ref
                  .read(ConversionsNotifier.provider.notifier)
                  .undoClearOperation();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    void openSearch() {
      ref.read(PropertiesOrderNotifier.provider).whenData((orderList) async {
        final selectedProperty = await showSearch<PROPERTYX?>(
          context: context,
          delegate: CustomSearchDelegate(orderList),
        );
        if (selectedProperty != null) {
          final String targetPath =
              '/conversions/${selectedProperty.toKebabCase()}';

          if (context.mounted &&
              GoRouterState.of(context).uri.toString() != targetPath) {
            context.go(targetPath);
          }
        }
      });
    }

    return LayoutBuilder(builder: (context, constraints) {
      // ignore: no_leading_underscores_for_local_identifiers
      final bool _isDrawerFixed = isDrawerFixed(constraints.maxWidth);

      AppPage selectedSection = computeSelectedSection(context);

      Widget drawer = CustomDrawer(
        isDrawerFixed: _isDrawerFixed,
        openCalculator: openCalculator,
        openSearch: openSearch,
      );

      final ret = _isDrawerFixed
          ? Scaffold(
              body: Row(
                children: <Widget>[
                  drawer,
                  Expanded(child: child),
                ],
              ),
              floatingActionButton: (selectedSection == AppPage.conversions &&
                      MediaQuery.viewInsetsOf(context).bottom == 0)
                  ? FloatingActionButton(
                      key: const ValueKey('clearAll'),
                      onPressed: () => clearAll(_isDrawerFixed),
                      tooltip: l10n.clearAll,
                      child: const Icon(Icons.clear_outlined),
                    )
                  : null,
            )
          : Scaffold(
              drawer: drawer,
              body: child,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endContained,
              bottomNavigationBar: selectedSection == AppPage.conversions
                  ? BottomAppBar(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            tooltip: l10n.search,
                            icon: const Icon(Icons.search),
                            onPressed: openSearch,
                          ),
                          IconButton(
                            tooltip: l10n.calculator,
                            icon: const Icon(Icons.calculate_outlined),
                            onPressed: openCalculator,
                          ),
                        ],
                      ),
                    )
                  : null,
              floatingActionButton: (selectedSection == AppPage.conversions &&
                      MediaQuery.viewInsetsOf(context).bottom == 0)
                  ? FloatingActionButton(
                      key: const ValueKey('clearAll'),
                      onPressed: () => clearAll(_isDrawerFixed),
                      tooltip: l10n.clearAll,
                      child: const Icon(Icons.clear_outlined),
                    )
                  : null,
            );

      return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK):
              const ActivateIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                openSearch();
                return null;
              },
            ),
          },
          child: ret,
        ),
      );
    });
  }
}
