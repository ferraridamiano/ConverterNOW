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

const _scaffoldKey = ValueKey<String>('App scaffold');

class MyApp extends StatelessWidget {
  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/conversions/:property',
        pageBuilder: (context, state) {
          final String property = state.params['property']!;
          final int? pageNumber = pageNumberMap[property];
          if (pageNumber == null) {
            throw Exception('property not found: $property');
          } else {
            return NoTransitionPage(
              key: _scaffoldKey,
              child: AppScaffold(
                selectedSection: AppPage.conversions,
                selectedIndex: pageNumber,
                child: ConversionPage(pageNumber),
              ),
            );
          }
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => const NoTransitionPage(
          key: _scaffoldKey,
          child: AppScaffold(
            selectedSection: AppPage.settings,
            child: SettingsPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/settings/reorder-properties',
        name: 'reorder-properties',
        pageBuilder: (context, state) => const NoTransitionPage(
          key: _scaffoldKey,
          child: AppScaffold(
            selectedSection: AppPage.reorder,
            child: ReorderPropertiesPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/settings/reorder-units',
        name: 'reorder-units',
        pageBuilder: (context, state) => const NoTransitionPage(
          key: _scaffoldKey,
          child: AppScaffold(
            selectedSection: AppPage.reorder,
            child: ChoosePropertyPage(),
          ),
        ),
      ),
      GoRoute(
        path: '/settings/reorder-units/:property',
        pageBuilder: (context, state) {
          final String property = state.params['property']!;
          final int? pageNumber = pageNumberMap[property];
          if (pageNumber == null) {
            throw Exception('property not found: $property');
          } else {
            return NoTransitionPage(
              key: _scaffoldKey,
              child: AppScaffold(
                selectedSection: AppPage.reorder_details,
                selectedIndex: pageNumber,
                child: ChoosePropertyPage(
                  selectedProperty: pageNumber,
                  isPropertySelected: true,
                ),
              ),
            );
          }
        },
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
            colorScheme:
                defaultLight.colorScheme.copyWith(secondary: Colors.orange),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.orange,
            ),
            /*primaryColor: Colors.teal[400],
            //primarySwatch: Colors.orange,
            brightness: Brightness.light,
            colorScheme: defaultLight.colorScheme.copyWith(
              secondary: Colors.orange,
              secondaryContainer: Colors.orange[700],
            ),
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              labelStyle: TextStyle(color: Color(0xFF555555)),
            ),
            bottomAppBarColor: const Color(0xFFEBF7F6),*/
          ),
          darkTheme: defaultDark.copyWith(
            useMaterial3: true,
            /*primaryColor: Colors.teal[400],
            colorScheme: defaultDark.colorScheme.copyWith(
              secondary: Colors.orange[600],
              secondaryContainer: Colors.orange[700],
            ),
            brightness: Brightness.dark,
            scaffoldBackgroundColor:
                isDarkAmoled ? Colors.black : Colors.grey[850],
            canvasColor: isDarkAmoled
                ? Colors.black
                : Colors.grey[850], // for drawer background
            cardColor: isDarkAmoled ? Colors.grey[900] : Colors.grey[800],
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              labelStyle: TextStyle(color: Color(0xFFDDDDDD)),
            ),
            bottomAppBarColor: isDarkAmoled
                ? const Color(0xFF0A2D2A)
                : const Color(0xFF3F4B4A),*/
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
