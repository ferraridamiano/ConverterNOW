import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

enum AppPage { conversions, settings, reorder }

AppPage computeSelectedSection(BuildContext context) {
  final String location = GoRouterState.of(context).uri.toString();

  if (location.startsWith('/settings/reorder-properties')) {
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
  // The path is used instead of the whole URI because the location may
  // contain a query parameter (e.g. '/conversions/length?unit=LENGTH.meters')
  // that would break the property parsing below.
  final location = GoRouterState.of(context).uri.path;
  if (location.startsWith('/conversions')) {
    return inversePropertiesOrdering[kebabStringToPropertyX(
      location.split('/')[2],
    )];
  }
  return null;
}
