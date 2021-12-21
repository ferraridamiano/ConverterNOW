import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/pages/custom_drawer.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.selectedSection,
    this.selectedIndex = 0,
    required this.child,
    Key? key,
  }) : super(key: key);

  final ScaffoldSection selectedSection;
  final int selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool _isDrawerFixed = isDrawerFixed(constraints.maxWidth);

      Widget drawer = CustomDrawer(
        isDrawerFixed: _isDrawerFixed,
        selectedSection: selectedSection,
        selectedIndex: selectedIndex,
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
        );
      }
      // if the drawer is not fixed
      return Scaffold(
        drawer: drawer,
        body: SafeArea(child: child),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}
