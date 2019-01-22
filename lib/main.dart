import 'package:converter_pro/ConversionManager.dart';
import 'package:converter_pro/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

double AD_SIZE=0.0;

void main() => runApp(new SandboxApp());


class SandboxApp extends StatefulWidget {
  @override
  _SandboxAppState createState() => _SandboxAppState();
}

class _SandboxAppState extends State<SandboxApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter NOW',
      home: ConversionManager(),
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.indigo,
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
    );
  }
}