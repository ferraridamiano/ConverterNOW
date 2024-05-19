import 'package:converterpro/app_router.dart';
import 'package:converterpro/styles/consts.dart';
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
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      if (lightDynamic != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(deviceAccentColorProvider.notifier).state =
              lightDynamic.primary,
        );
      }

      return Consumer(builder: (context, ref, child) {
        final settingsLocale = ref.watch(CurrentLocale.provider).valueOrNull;
        final themeColor = ref.watch(ThemeColorNotifier.provider).valueOrNull ??
            (useDeviceColor: false, colorTheme: fallbackColorTheme);

        final ThemeData lightTheme, darkTheme;
        // Use device accent color
        if (ref.watch(deviceAccentColorProvider) != null &&
            themeColor.useDeviceColor) {
          lightTheme = ThemeData(
            colorScheme: lightDynamic!.harmonized(),
          );
          darkTheme = ThemeData(
            brightness: Brightness.dark,
            colorScheme: darkDynamic!.harmonized(),
          );
        } else {
          lightTheme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeColor.colorTheme,
            ),
          );
          darkTheme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: themeColor.colorTheme,
              brightness: Brightness.dark,
            ),
            brightness: Brightness.dark,
          );
        }
        final amoledTheme = darkTheme.copyWith(
          scaffoldBackgroundColor: Colors.black,
          drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
        );

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
