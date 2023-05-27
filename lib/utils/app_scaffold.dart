import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:calculator_widget/calculator_widget.dart';
import 'package:converterpro/pages/custom_drawer.dart';
import 'package:converterpro/pages/search_page.dart';
import 'package:converterpro/utils/navigator_utils.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    void openCalculator() {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) {
          return CalculatorWidget();
        },
      );
    }

    void clearAll(bool isDrawerFixed) {
      final int page = pageNumberMap[
          GoRouter.of(context).location.substring('/conversions/'.length)]!;
      if (context.read<Conversions>().shouldShowSnackbar(page)) {
        context.read<Conversions>().clearAllValues(page);
        //Snackbar undo request
        final SnackBar snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.undoClearAllMessage),
          behavior: SnackBarBehavior.floating,
          width: isDrawerFixed ? 400 : null,
          action: SnackBarAction(
            key: const ValueKey('undoClearAll'),
            label: AppLocalizations.of(context)!.undo,
            onPressed: () {
              context.read<Conversions>().undoClearOperation();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    void openSearch() async {
      final orderList = context.read<AppModel>().conversionsOrderDrawer;
      final int? newPage = await showSearch(
        context: context,
        delegate: CustomSearchDelegate(orderList!),
      );
      if (newPage != null) {
        final String targetPath =
            '/conversions/${reversePageNumberListMap[newPage]}';
        // ignore: use_build_context_synchronously
        if (GoRouter.of(context).location != targetPath) {
          // ignore: use_build_context_synchronously
          context.go(targetPath);
        }
      }
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

      //if the drawer is fixed
      if (_isDrawerFixed) {
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: <Widget>[
                drawer,
                Expanded(child: child),
              ],
            ),
          ),
          floatingActionButton: (selectedSection == AppPage.conversions &&
                  MediaQuery.of(context).viewInsets.bottom == 0)
              ? FloatingActionButton(
                  key: const ValueKey('clearAll'),
                  onPressed: () => clearAll(_isDrawerFixed),
                  tooltip: AppLocalizations.of(context)!.clearAll,
                  child: const Icon(Icons.clear_outlined),
                )
              : null,
        );
      }
      // if the drawer is not fixed
      return WillPopScope(
        onWillPop: () async {
          switch (selectedSection) {
            case AppPage.settings:
              context.go('/');
              return false;
            case AppPage.reorder:
              context.goNamed('settings');
              return false;
            case AppPage.reorderDetails:
              //2 sided page
              if (_isDrawerFixed) {
                context.goNamed('settings');
              } else {
                context.goNamed('reorder-units');
              }
              return false;
            default:
              return true;
          }
        },
        child: Scaffold(
          drawer: drawer,
          body: SafeArea(child: child),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
          bottomNavigationBar: selectedSection == AppPage.conversions
              ? BottomAppBar(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.search,
                        icon: const Icon(Icons.search),
                        onPressed: openSearch,
                      ),
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.calculator,
                        icon: const Icon(Icons.calculate_outlined),
                        onPressed: openCalculator,
                      ),
                    ],
                  ),
                )
              : null,
          floatingActionButton: (selectedSection == AppPage.conversions &&
                  MediaQuery.of(context).viewInsets.bottom == 0)
              ? FloatingActionButton(
                  key: const ValueKey('clearAll'),
                  onPressed: () => clearAll(_isDrawerFixed),
                  tooltip: AppLocalizations.of(context)!.clearAll,
                  child: const Icon(Icons.clear_outlined),
                )
              : null,
        ),
      );
    });
  }
}
