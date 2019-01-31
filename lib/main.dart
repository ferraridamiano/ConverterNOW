import 'package:converter_pro/ConversionManager.dart';
import 'package:converter_pro/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

double AD_SIZE=0.0;
bool darkTheme=false;
SharedPreferences prefs;

void main() async {
  Brightness brightness;
  prefs = await SharedPreferences.getInstance();
  darkTheme = prefs.getBool("darkTheme") ?? false;
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

  /*@override
  void initState() {
    super.initState();
  }*/

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
          title: 'Flutter Demo',
          theme: theme,
          home: MaterialApp(
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