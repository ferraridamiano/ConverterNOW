import 'package:converter_pro/ConversionManager.dart';
import 'package:converter_pro/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

bool darkTheme=false;
bool isLogoVisible=true;
SharedPreferences prefs;
int numero_volte_accesso;

void main() async {
  Brightness brightness;
  prefs = await SharedPreferences.getInstance();
  darkTheme = prefs.getBool("darkTheme") ?? false;
  isLogoVisible = prefs.getBool("isLogoVisible") ?? true;
  numero_volte_accesso=prefs.getInt("access_number") ?? 0;
  numero_volte_accesso++;
  print(numero_volte_accesso);
  if(numero_volte_accesso<5)                                  //traccio solo i primi 5 accessi per dialog rating
    prefs.setInt("access_number", numero_volte_accesso);
  brightness = darkTheme ? Brightness.dark: Brightness.light;
  runApp(new SandboxApp(brightness));
}


class SandboxApp extends StatefulWidget {
  Brightness brightness;
  SandboxApp(this.brightness);
  @override
  _SandboxAppState createState() => _SandboxAppState();
}

class _SandboxAppState extends State<SandboxApp> {

  @override
  Widget build(BuildContext context) {

    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.indigo,
        brightness: widget.brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(
          debugShowCheckedModeBanner:false,
          title: 'Converter NOW',
          theme: theme,
          home: MaterialApp(
            debugShowCheckedModeBanner:false,
            title: 'Converter NOW',
            home: ConversionManager(),
            theme: ThemeData(
            primaryColor: Colors.red,
            accentColor: Colors.indigo,
            brightness: darkTheme ? Brightness.dark : Brightness.light
        ),
        supportedLocales: [
        const Locale('en', 'US'),
        const Locale('it', 'IT')
        ],
      localizationsDelegates: [
        const MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
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
    );
  }
}