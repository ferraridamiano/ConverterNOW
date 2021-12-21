/*import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/calculator.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/pages/calculator_widget.dart';
import 'package:converterpro/pages/choose_property_page.dart';
import 'package:converterpro/pages/conversion_page.dart';
import 'package:converterpro/pages/reorder_page.dart';
import 'package:converterpro/pages/search_page.dart';
import 'package:converterpro/pages/settings_page.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainPage extends StatelessWidget {

  final int pageNumber;

  const MainPage(this.pageNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openCalculator() {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return ChangeNotifierProvider(
              create: (_) => Calculator(decimalSeparator: '.'),
              child: const CalculatorWidget(),
            );
          });
    }

    void clearAll() {
      if (context.read<Conversions>().shouldShowSnackbar()) {
        context.read<Conversions>().clearAllValues();
        final double width = MediaQuery.of(context).size.width;
        //Snackbar undo request
        final SnackBar snackBar = SnackBar(
          content: Text(AppLocalizations.of(context)!.undoClearAllMessage),
          behavior: SnackBarBehavior.floating,
          width: width > pixelFixedDrawer ? 400 : null,
          action: SnackBarAction(
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
        delegate: CustomSearchDelegate(orderList),
      );
      if (newPage != null) {
        AppModel appModel = context.read<AppModel>();
        if (appModel.currentPage != newPage) appModel.changeToPage(newPage);
      }
    }

    // Read the order of the properties in the drawer
    List<int> conversionsOrderDrawer = context.watch<AppModel>().conversionsOrderDrawer;
    List<String> propertyNameList = getPropertyNameList(context);
    List<String> orderedDrawerList = List.filled(conversionsOrderDrawer.length, "");
    for (int i = 0; i < conversionsOrderDrawer.length; i++) {
      orderedDrawerList[conversionsOrderDrawer[i]] = propertyNameList[i];
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final bool _isDrawerFixed = isDrawerFixed(constraints.maxWidth);

      // Get the current main screen
      MAIN_SCREEN currentScreen = MAIN_SCREEN.conversion;//context.select<AppModel, MAIN_SCREEN>((appModel) => appModel.currentScreen);
      // And build the right widget
      Widget mainScreen;
      switch (currentScreen) {
        case MAIN_SCREEN.settings:
          mainScreen = _isDrawerFixed
              ? const SettingsPage()
              : WillPopScope(
                  child: const SettingsPage(),
                  onWillPop: () async {
                    context.read<AppModel>().currentScreen = MAIN_SCREEN.conversion;
                    return false;
                  },
                );
          break;
        case MAIN_SCREEN.reorderProperties:
          mainScreen = Expanded(
            child: WillPopScope(
              onWillPop: () async {
                context.read<AppModel>().currentScreen = MAIN_SCREEN.settings;
                return false;
              },
              child: ReorderPage(
                header: BigTitle(
                  text: AppLocalizations.of(context)!.reorderProperties,
                  center: true,
                ),
                itemsList: orderedDrawerList,
                onSave: (List<int>? orderList) {
                  context.read<AppModel>()
                    ..saveOrderDrawer(orderList)
                    ..currentScreen = MAIN_SCREEN.settings;
                },
              ),
            ),
          );
          break;
        case MAIN_SCREEN.reorderUnits:
          var _page = ChoosePropertyPage(
            orderedDrawerList: orderedDrawerList,
          );
          mainScreen = _isDrawerFixed
              ? _page
              : WillPopScope(
                  child: _page,
                  onWillPop: () async {
                    context.read<AppModel>().currentScreen = MAIN_SCREEN.settings;
                    return false;
                  },
                );
          break;
        case MAIN_SCREEN.conversion:
        default:
          mainScreen = ConversionPage(pageNumber);
          break;
      }

      Widget drawer = CustomDrawer(
        isDrawerFixed: _isDrawerFixed,
        openCalculator: openCalculator,
        openSearch: openSearch,
        initalPage: MAIN_SCREEN.conversion,
        initialPageNumber: pageNumber,
      );

      //if the drawer is fixed
      if (_isDrawerFixed) {
        return Scaffold(
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                drawer,
                mainScreen,
              ],
            ),
          ),
          floatingActionButton:
              (currentScreen == MAIN_SCREEN.conversion && MediaQuery.of(context).viewInsets.bottom == 0)
                  ? FloatingActionButton(
                      child: const Icon(
                        Icons.clear_outlined,
                        color: Colors.white,
                      ),
                      onPressed: clearAll,
                      tooltip: AppLocalizations.of(context)!.clearAll,
                    )
                  : null,
        );
      }
      // if the drawer is not fixed
      return Scaffold(
        drawer: drawer,
        body: SafeArea(
            child: Row(
          children: [
            mainScreen,
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: currentScreen == MAIN_SCREEN.conversion
            ? BottomAppBar(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Builder(builder: (context) {
                      return IconButton(
                          tooltip: AppLocalizations.of(context)!.menu,
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          });
                    }),
                    if (currentScreen == MAIN_SCREEN.conversion)
                      IconButton(
                        tooltip: AppLocalizations.of(context)!.clearAll,
                        icon: const Icon(Icons.clear),
                        onPressed: clearAll,
                      ),
                  ],
                ),
              )
            : null,
        floatingActionButton: (currentScreen == MAIN_SCREEN.conversion && MediaQuery.of(context).viewInsets.bottom == 0)
            ? FloatingActionButton(
                tooltip: AppLocalizations.of(context)!.calculator,
                child: const Icon(
                  Icons.calculate_outlined,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: openCalculator,
                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
              )
            : null,
      );
    });
  }
}
*/