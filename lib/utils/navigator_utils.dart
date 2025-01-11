import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppPage { conversions, settings, reorder, reorderDetails }

AppPage computeSelectedSection(BuildContext context) {
  final String location = GoRouterState.of(context).uri.toString();

  if (location.startsWith('/conversions/')) {
    return AppPage.conversions;
  }
  if (location.startsWith('/settings/reorder-properties')) {
    return AppPage.reorder;
  }
  if (location.startsWith('/settings/reorder-units/') &&
      location.split('/')[3] != '') {
    return AppPage.reorderDetails;
  }
  if (location.startsWith('/settings/reorder-units')) {
    return AppPage.reorder;
  }
  if (location.startsWith('/settings')) {
    return AppPage.settings;
  }
  return AppPage.conversions;
}

int? computeSelectedConversionPage(
    BuildContext context, Map<PROPERTYX, int> inversePropertiesOrdering) {
  final segments = GoRouterState.of(context).uri.pathSegments;

  if (segments.isNotEmpty && segments[0] == 'conversions') {
    return inversePropertiesOrdering[segments.last.kebab2PropertyX()];
  }
  return null;
}
