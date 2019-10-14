import 'package:converter_pro/ConversionManager.dart';
import 'package:converter_pro/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogoVisible = true;
SharedPreferences prefs;
int numero_volte_accesso;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  isLogoVisible = prefs.getBool("isLogoVisible") ?? true;
  numero_volte_accesso = prefs.getInt("access_number") ?? 0;
  numero_volte_accesso++;
  print(numero_volte_accesso);
  if (numero_volte_accesso <
      5) //traccio solo i primi 5 accessi per dialog rating
    prefs.setInt("access_number", numero_volte_accesso);
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Converter NOW',
      home: ConversionManager(),
      theme: ThemeData(
          primaryColor: Color(0xFFF44336),
          accentColor: Color(0xFF03A9F4),
          brightness: Brightness.light),
      darkTheme: ThemeData(
        primaryColor: Color(0xFFF44336),
        accentColor: Color(0xFF03A9F4),
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
    );
  }
}
