import 'package:converterpro/pages/error_page.dart';
import 'package:converterpro/pages/reorder_units_page.dart';
import 'package:converterpro/pages/conversion_page.dart';
import 'package:converterpro/pages/reorder_properties_page.dart';
import 'package:converterpro/pages/settings_page.dart';
import 'package:converterpro/pages/splash_screen.dart';
import 'package:converterpro/utils/app_scaffold.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:translations/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class MyApp extends StatelessWidget {
  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      // TODO fix error with this route
      GoRoute(
        path: '/',
        builder: (context, _) => const SplashScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/conversions/:property',
            builder: (context, state) {
              final String property = state.params['property']!;
              final int? pageNumber = pageNumberMap[property];
              if (pageNumber == null) {
                throw Exception('property not found: $property');
              } else {
                return ConversionPage(pageNumber);
              }
            },
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/settings/reorder-properties',
            name: 'reorder-properties',
            builder: (context, state) => const ReorderPropertiesPage(),
          ),
          GoRoute(
            path: '/settings/reorder-units',
            name: 'reorder-units',
            builder: (context, state) => const ChoosePropertyPage(),
          ),
          GoRoute(
            path: '/settings/reorder-units/:property',
            builder: (context, state) {
              final String property = state.params['property']!;
              final int? pageNumber = pageNumberMap[property];
              if (pageNumber == null) {
                throw Exception('property not found: $property');
              } else {
                return ChoosePropertyPage(
                  selectedProperty: pageNumber,
                  isPropertySelected: true,
                );
              }
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool deviceLocaleSetted = false;
    final ThemeData defaultLight = ThemeData();
    final ThemeData defaultDark = ThemeData.dark();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppModel()),
        ChangeNotifierProvider(create: (context) => Conversions()),
      ],
      child: Builder(builder: (BuildContext context) {
        bool isDarkAmoled = context.select<AppModel, bool>(
          (appModel) => appModel.isDarkAmoled,
        );
        return MaterialApp.router(
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: 'Converter NOW',
          themeMode: context.select<AppModel, ThemeMode>(
            (appModel) => appModel.currentThemeMode,
          ),
          theme: defaultLight.copyWith(
            useMaterial3: true,
            primaryColor: Colors.teal[400],
            colorScheme: defaultLight.colorScheme.copyWith(
              secondary: Colors.orange,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.orange,
            ),
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Colors.teal[400]),
            toggleableActiveColor: Colors.orange,
          ),
          darkTheme: defaultDark.copyWith(
            useMaterial3: true,
            primaryColor: Colors.teal[400],
            colorScheme: defaultDark.colorScheme.copyWith(
              secondary: Colors.orange,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.orange,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.teal[400],
            ),
            toggleableActiveColor: Colors.orange,
            scaffoldBackgroundColor:
                isDarkAmoled ? Colors.black : Colors.grey[850],
            canvasColor: isDarkAmoled
                ? Colors.black
                : Colors.grey[850], // for drawer background
          ),
          supportedLocales: context.read<AppModel>().supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback:
              (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
            if (!deviceLocaleSetted) {
              context.read<AppModel>().deviceLocale = deviceLocale;
              deviceLocaleSetted = true;
            }
            return deviceLocale;
          },
          locale: context.select<AppModel, Locale?>(
            (appModel) => appModel.appLocale,
          ),
        );
      }),
    );
  }
}
