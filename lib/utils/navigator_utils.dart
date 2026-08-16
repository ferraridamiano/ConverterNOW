import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
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
  if (location.startsWith('/reorder-units/') &&
      location.split('/')[2] != '') {
    return AppPage.reorderDetails;
  }
  if (location.startsWith('/reorder-units')) {
    return AppPage.reorder;
  }
  if (location.startsWith('/hide-units/') && location.split('/')[2] != '') {
    return AppPage.reorderDetails;
  }
  if (location.startsWith('/hide-units')) {
    return AppPage.reorder;
  }
  if (location.startsWith('/settings')) {
    return AppPage.settings;
  }
  return AppPage.conversions;
}

int? computeSelectedConversionPage(
  BuildContext context,
  Map<PROPERTYX, int> inversePropertiesOrdering,
) {
  final location = GoRouterState.of(context).uri.toString();
  if (location.startsWith('/conversions')) {
    return inversePropertiesOrdering[kebabStringToPropertyX(
      location.split('/').last,
    )];
  }
  return null;
}
