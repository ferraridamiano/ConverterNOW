import 'package:converterpro/models/Settings.dart';
import 'package:converterpro/utils/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'managers/AppManager.dart';

bool isLogoVisible = true;
SharedPreferences prefs;
int numeroVolteAccesso;
int significantFigures;
bool removeTrailingZeros;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  isLogoVisible = prefs.getBool("isLogoVisible") ?? true;
  numeroVolteAccesso = prefs.getInt("access_number") ?? 0;
  significantFigures = prefs.getInt("significant_figures") ?? 10;
  removeTrailingZeros = prefs.getBool("remove_trailing_zeros") ?? true;
  numeroVolteAccesso++;
  print(numeroVolteAccesso);
  if (numeroVolteAccesso < 5) //traccio solo i primi 5 accessi per dialog rating
    prefs.setInt("access_number", numeroVolteAccesso);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings(),
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Converter NOW',
        home: AppManager(),
        theme: ThemeData(
            primaryColor: Color(0xFFF2542D),
            accentColor: Color(0xFF0E9594),
            brightness: Brightness.light),
        darkTheme: ThemeData(
          primaryColor: Color(0xFFF2542D),
          accentColor: Color(0xFF0E9594),
          brightness: Brightness.dark),
        supportedLocales: [const Locale('en', 'US'), const Locale('it', 'IT')],
        localizationsDelegates: [
          const MyLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode ||
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
