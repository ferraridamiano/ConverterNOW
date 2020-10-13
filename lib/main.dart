import 'package:converterpro/utils/Localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'managers/AppManager.dart';
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
        ChangeNotifierProvider(create: (_) => AppModel()),
        ChangeNotifierProvider(create: (_) => Conversions(),),
      ],
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
