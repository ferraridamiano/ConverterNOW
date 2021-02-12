import 'package:converterpro/pages/AppManager.dart';
import 'package:converterpro/pages/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'models/AppModel.dart';
import 'models/Conversions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppModel(),
        ),
        ChangeNotifierProxyProvider<AppModel, Conversions>(
          create: (context) => Conversions(),
          update: (context, appModel, conversions) {
            conversions.currentPage = appModel.currentPage;
            return conversions;
          },
        ),
        /*ChangeNotifierProvider(
          create: (_) => Conversions(),
        ),*/
      ],
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Converter NOW',
        initialRoute: '/',
        routes: {
          '/': (context) => AppManager(),
          '/settings': (context) => SettingsPage(),
        },
        theme: ThemeData(primaryColor: Color(0xFFF2542D), accentColor: Color(0xFF0E9594), brightness: Brightness.light),
        darkTheme: ThemeData(primaryColor: Color(0xFFF2542D), accentColor: Color(0xFF0E9594), brightness: Brightness.dark),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
