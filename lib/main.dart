import 'package:converterpro/pages/ConversionPage.dart';
import 'package:converterpro/pages/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  bool deviceLocaleSetted = false;
  
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
            conversions?.currentPage = appModel.currentPage;
            return conversions!;
          },
        ),
      ],
      child: Builder(builder: (BuildContext context) {
        bool isDarkAmoled = context.select<AppModel, bool>((appModel) => appModel.isDarkAmoled);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Converter NOW',
          initialRoute: '/',
          routes: {
            '/': (context) => ConversionPage(),
            '/settings': (context) => SettingsPage(),
          },
          themeMode: context.select<AppModel, ThemeMode>((appModel) => appModel.currentThemeMode),
          theme: ThemeData(primaryColor: Color(0xFFF2542D), accentColor: Color(0xFF0E9594), brightness: Brightness.light),
          darkTheme: ThemeData(
            primaryColor: const Color(0xFFF2542D),
            accentColor: const Color(0xFF0E9594),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: isDarkAmoled ? Colors.black : Colors.grey[850],
            canvasColor: isDarkAmoled ? Colors.black : Colors.grey[850], // for drawer background
            cardColor: isDarkAmoled ? Colors.grey[900] : Colors.grey[800],
          ),
          supportedLocales: context.read<AppModel>().supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          localeResolutionCallback: (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
            if(!deviceLocaleSetted){
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
