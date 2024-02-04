import 'package:converterpro/app_router.dart';
import 'package:universal_io/io.dart';
import 'package:converterpro/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color fallbackColorSchemeSeed = Colors.blue;

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;
      if (lightDynamic != null && darkDynamic != null) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: fallbackColorSchemeSeed,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: fallbackColorSchemeSeed,
          brightness: Brightness.dark,
        );
      }

      ThemeData lightTheme = ThemeData(colorScheme: lightColorScheme);
      ThemeData darkTheme = ThemeData(
        brightness: Brightness.dark,
        colorScheme: darkColorScheme,
      );
      ThemeData amoledTheme = darkTheme.copyWith(
        scaffoldBackgroundColor: Colors.black,
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
      );

      return Consumer(builder: (context, ref, child) {
        Locale? settingsLocale = ref.watch(CurrentLocale.provider).valueOrNull;
        String deviceLocaleLanguageCode = Platform.localeName.split('_')[0];
        Locale appLocale;
        if (settingsLocale != null) {
          appLocale = settingsLocale;
        } else if (mapLocale.keys
            .map((Locale locale) => locale.languageCode)
            .contains(deviceLocaleLanguageCode)) {
          appLocale = Locale(deviceLocaleLanguageCode);
        } else {
          appLocale = const Locale('en');
        }

        final appRouter = ref.read(routerProvider);

        return MaterialApp.router(
          routeInformationProvider: appRouter.routeInformationProvider,
          routeInformationParser: appRouter.routeInformationParser,
          routerDelegate: appRouter.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: 'Converter NOW',
          themeMode: ref.watch(CurrentThemeMode.provider).valueOrNull ??
              ThemeMode.system,
          theme: lightTheme,
          darkTheme: (ref.watch(IsDarkAmoled.provider).valueOrNull ?? false)
              ? amoledTheme
              : darkTheme,
          supportedLocales: mapLocale.keys,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: appLocale,
        );
      });
    });
  }
}
