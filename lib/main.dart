import 'dart:io';
import 'package:converterpro/app_router.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:converterpro/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:window_manager/window_manager.dart' show windowManager;
import 'helpers/app_window_manager.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['Josefin Sans'],
      await rootBundle.loadString('assets/fonts/OFL.txt'),
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    await AppWindowManager.setupWindowPersistence();
  }

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

        ThemeData lightTheme, darkTheme;
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
        ThemeData amoledTheme = darkTheme.copyWith(
          scaffoldBackgroundColor: Colors.black,
          drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
        );

        const pageTransitionsTheme = PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          },
        );
        lightTheme =
            lightTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme);
        darkTheme =
            darkTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme);
        amoledTheme =
            amoledTheme.copyWith(pageTransitionsTheme: pageTransitionsTheme);
        final themeMode = ref.watch(CurrentThemeMode.provider).valueOrNull ??
            ThemeMode.system;

        // Workaround until https://github.com/flutter/flutter/issues/39998 got
        // resolved
        String deviceLocaleLanguageCode =
            kIsWeb ? 'en' : Platform.localeName.split('_')[0];
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
          themeMode: themeMode,
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
