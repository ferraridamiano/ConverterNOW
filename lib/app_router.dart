import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/models/properties_list.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/pages/conversion_page.dart';
import 'package:converterpro/pages/error_page.dart';
import 'package:converterpro/pages/hide_units_page.dart';
import 'package:converterpro/pages/reorder_properties_page.dart';
import 'package:converterpro/pages/reorder_units_page.dart';
import 'package:converterpro/pages/settings_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/pages/app_scaffold.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:translations/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

final isEverythingLoadedProvider = Provider<bool>((ref) =>
    ref.watch(SignificantFigures.provider).hasValue &&
    ref.watch(RemoveTrailingZeros.provider).hasValue &&
    ref.watch(IsPureDark.provider).hasValue &&
    ref.watch(ThemeColorNotifier.provider).hasValue &&
    ref.watch(RevokeInternetNotifier.provider).hasValue &&
    ref.watch(CurrentThemeMode.provider).hasValue &&
    ref.watch(CurrentLocale.provider).hasValue &&
    ref.watch(PropertiesOrderNotifier.provider).hasValue &&
    ref.watch(UnitsOrderNotifier.provider).hasValue &&
    ref.watch(ConversionsNotifier.provider).hasValue &&
    ref.watch(HiddenUnitsNotifier.provider).hasValue &&
    ref.watch(propertiesMapProvider).hasValue);

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/conversions/:property',
            builder: (context, state) {
              final String property = state.pathParameters['property']!;
              final propertyx = kebabStringToPropertyX(property);
              return ConversionPage(propertyx);
            },
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'reorder-properties',
                name: 'reorder-properties',
                builder: (context, state) => const ReorderPropertiesPage(),
              ),
              GoRoute(
                path: 'reorder-units',
                name: 'reorder-units',
                builder: (context, state) => const ReorderUnitsPage(),
                routes: [
                  GoRoute(
                    path: ':property',
                    builder: (context, state) {
                      final String property = state.pathParameters['property']!;
                      final propertyx = kebabStringToPropertyX(property);
                      return ReorderUnitsPage(
                        selectedProperty: propertyx,
                        isPropertySelected: true,
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'hide-units',
                name: 'hide-units',
                builder: (context, state) => const HideUnitsPage(),
                routes: [
                  GoRoute(
                    path: ':property',
                    builder: (context, state) {
                      final String property = state.pathParameters['property']!;
                      final propertyx = kebabStringToPropertyX(property);
                      return HideUnitsPage(
                        selectedProperty: propertyx,
                        isPropertySelected: true,
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'about',
                name: 'about',
                builder: (context, state) => LicensePage(
                  applicationName: AppLocalizations.of(context)!.appName,
                  applicationIcon: const SvgPicture(
                    AssetBytesLoader('assets/app_icons_opti/logo.svg.vec'),
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // Bypass splashscreen if variables are already loaded
      if (state.uri.toString() == '/') {
        if (ref.read(isEverythingLoadedProvider)) {
          final conversionsOrderDrawer =
              ref.read(PropertiesOrderNotifier.provider).value!;
          return '/conversions/${conversionsOrderDrawer[0].toKebabCase()}';
        }
      }
      return null;
    },
    errorBuilder: (context, state) => const ErrorPage(),
  ),
);
