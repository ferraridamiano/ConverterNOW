import 'package:converterpro/pages/conversion_page.dart';
import 'package:converterpro/pages/settings_page.dart';
import 'package:converterpro/utils/app_scaffold.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

const _scaffoldKey = ValueKey<String>('App scaffold');

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  bool deviceLocaleSetted = false;

  final _router = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        path: '/',
        redirect: (_) => '/conversions/length',
      ),
      GoRoute(
        path: '/conversions/:property',
        pageBuilder: (context, state) {
          final String property = state.params['property']!;
          final int? pageNumber = pageNumberMap[property];
          if (pageNumber == null) {
            throw Exception('property not found: $property');
          } else {
            return FadeTransitionPage(
              key: _scaffoldKey,
              child: AppScaffold(
                selectedSection: ScaffoldSection.conversions,
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
        pageBuilder: (context, state) => FadeTransitionPage(
          key: _scaffoldKey,
          child: const AppScaffold(selectedSection: ScaffoldSection.settings, child: SettingsPage()),
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData defaultLight = ThemeData();
    final ThemeData defaultDark = ThemeData.dark();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppModel(),
        ),
        ChangeNotifierProxyProvider<AppModel, Conversions>(
          create: (context) => Conversions(),
          update: (context, appModel, conversions) {
            conversions?.currentPage = appModel.currentPage;
            return conversions!;
          },
        ),
      ],
      child: Builder(builder: (BuildContext context) {
        bool isDarkAmoled = context.select<AppModel, bool>((appModel) => appModel.isDarkAmoled);
        return MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: 'Converter NOW',
          themeMode: context.select<AppModel, ThemeMode>((appModel) => appModel.currentThemeMode),
          theme: defaultLight.copyWith(
            primaryColor: Colors.teal[400],
            //primarySwatch: Colors.orange,
            brightness: Brightness.light,
            colorScheme: defaultLight.colorScheme.copyWith(
              secondary: Colors.orange,
              secondaryVariant: Colors.orange[700],
            ),
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
              labelStyle: TextStyle(color: Color(0xFF555555)),
            ),
            bottomAppBarColor: const Color(0xFFEBF7F6),
          ),
          darkTheme: defaultDark.copyWith(
            primaryColor: Colors.teal[400],
            colorScheme: defaultDark.colorScheme.copyWith(
              secondary: Colors.orange[600],
              secondaryVariant: Colors.orange[700],
            ),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: isDarkAmoled ? Colors.black : Colors.grey[850],
            canvasColor: isDarkAmoled ? Colors.black : Colors.grey[850], // for drawer background
            cardColor: isDarkAmoled ? Colors.grey[900] : Colors.grey[800],
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
              labelStyle: TextStyle(color: Color(0xFFDDDDDD)),
            ),
            bottomAppBarColor: isDarkAmoled ? const Color(0xFF0A2D2A) : const Color(0xFF3F4B4A),
          ),
          supportedLocales: context.read<AppModel>().supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
            if (!deviceLocaleSetted) {
              context.read<AppModel>().deviceLocale = deviceLocale;
              deviceLocaleSetted = true;
            }
            return deviceLocale;
          },
          locale: context.select<AppModel, Locale?>((appModel) => appModel.appLocale),
        );
      }),
    );
  }
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (c, animation, a2, child) => FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final _curveTween = CurveTween(curve: Curves.easeIn);
}
