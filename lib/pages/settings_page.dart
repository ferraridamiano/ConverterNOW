import 'dart:io';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translations/app_localizations.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_graphics/vector_graphics.dart';

class EnvironmentConfig {
  static const bool isPlaystore =
      String.fromEnvironment('IS_PLAYSTORE', defaultValue: 'false') == 'true';
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const List<int> significantFiguresList = [6, 8, 10, 12, 14];
  static const TextStyle textStyle = TextStyle(fontSize: singlePageTextSize);
  static const BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(30));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<ThemeMode, String> mapTheme = {
      ThemeMode.system: AppLocalizations.of(context)!.system,
      ThemeMode.dark: AppLocalizations.of(context)!.dark,
      ThemeMode.light: AppLocalizations.of(context)!.light,
    };

    updateNavBarColor(Theme.of(context).colorScheme);

    Color iconColor = getIconColor(Theme.of(context));

    return CustomScrollView(slivers: <Widget>[
      SliverAppBar.large(title: Text(AppLocalizations.of(context)!.settings)),
      SliverList(
          delegate: SliverChildListDelegate([
        DropdownListTile(
          key: const ValueKey('language'),
          leading: Icon(Icons.language, color: iconColor),
          title: AppLocalizations.of(context)!.language,
          textStyle: textStyle,
          items: [AppLocalizations.of(context)!.system, ...mapLocale.values],
          value: mapLocale[ref.watch(CurrentLocale.provider).valueOrNull] ??
              AppLocalizations.of(context)!.system,
          onChanged: (String? string) {
            if (string != null) {
              ref.read(CurrentLocale.provider.notifier).set(
                    string == AppLocalizations.of(context)!.system
                        ? null
                        : mapLocale.keys.firstWhere(
                            (element) => mapLocale[element] == string,
                          ),
                  );
            }
          },
        ),
        DropdownListTile(
          leading: Icon(Icons.palette_outlined, color: iconColor),
          title: AppLocalizations.of(context)!.theme,
          textStyle: textStyle,
          items: mapTheme.values.toList(),
          value:
              mapTheme[ref.watch(CurrentThemeMode.provider).valueOrNull ?? 0]!,
          onChanged: (String? string) {
            ref.read(CurrentThemeMode.provider.notifier).set(
                mapTheme.keys.where((key) => mapTheme[key] == string).single);
          },
        ),
        SwitchListTile(
          secondary: Icon(Icons.dark_mode_outlined, color: iconColor),
          title: Text(
            AppLocalizations.of(context)!.amoledDarkTheme,
            style: textStyle,
          ),
          value: ref.watch(IsDarkAmoled.provider).valueOrNull ?? false,
          activeColor: Theme.of(context).colorScheme.secondary,
          onChanged: (bool val) {
            ref.read(IsDarkAmoled.provider.notifier).set(val);
          },
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        SwitchListTile(
          secondary: SvgPicture(
            const AssetBytesLoader(
                'assets/app_icons/remove_trailing_zeros.svg.vec'),
            width: 25,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: Text(
            AppLocalizations.of(context)!.removeTrailingZeros,
            style: textStyle,
          ),
          value: ref.watch(RemoveTrailingZeros.provider).valueOrNull ?? true,
          activeColor: Theme.of(context).colorScheme.secondary,
          onChanged: (bool val) {
            ref.read(RemoveTrailingZeros.provider.notifier).set(val);
          },
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        DropdownListTile(
          leading: SvgPicture(
            const AssetBytesLoader(
                'assets/app_icons/significant_figures.svg.vec'),
            width: 25,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: AppLocalizations.of(context)!.significantFigures,
          textStyle: textStyle,
          items: significantFiguresList.map((e) => e.toString()).toList(),
          value: (ref.watch(SignificantFigures.provider).valueOrNull ?? 10)
              .toString(),
          onChanged: (String? string) {
            if (string != null) {
              ref
                  .read(SignificantFigures.provider.notifier)
                  .set(int.parse(string));
            }
          },
        ),
        ListTile(
          key: const ValueKey('reorder-properties'),
          leading: SvgPicture(
            const AssetBytesLoader(
                'assets/app_icons/reorder_properties.svg.vec'),
            width: 25,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: Text(
            AppLocalizations.of(context)!.reorderProperties,
            style: textStyle,
          ),
          onTap: () => context.goNamed('reorder-properties'),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        ListTile(
          key: const ValueKey('reorder-units'),
          leading: SvgPicture(
            const AssetBytesLoader('assets/app_icons/reorder_units.svg.vec'),
            width: 25,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
          title: Text(
            AppLocalizations.of(context)!.reorderUnits,
            style: textStyle,
          ),
          onTap: () => context.goNamed('reorder-units'),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        ListTile(
          leading: Icon(Icons.computer, color: iconColor),
          title: Text(
            AppLocalizations.of(context)!.otherPlatforms,
            style: textStyle,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(AppLocalizations.of(context)!.otherPlatforms),
                children: [
                  if (!kIsWeb)
                    ListTile(
                      title: const Text('Web'),
                      leading: const Icon(Icons.public_outlined),
                      onTap: () => launchURL(
                        Uri(
                          scheme: 'https',
                          host: 'converter-now.web.app',
                        ),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                  if (kIsWeb || Platform.isWindows || Platform.isLinux)
                    ListTile(
                      title: const Text('Android'),
                      leading: const Icon(Icons.android_outlined),
                      onTap: () => launchURL(Uri(
                        scheme: 'https',
                        host: 'play.google.com',
                        path: '/store/apps/details',
                        queryParameters: {'id': 'com.ferrarid.converterpro'},
                      )),
                    ),
                  if (kIsWeb || Platform.isAndroid || Platform.isLinux)
                    ListTile(
                      title: const Text('Windows'),
                      leading: const Icon(Icons.laptop),
                      onTap: () => launchURL(
                        Uri(
                          scheme: 'https',
                          host: 'microsoft.com',
                          path: '/store/apps/9P0Q79HWJH72',
                        ),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                  ListTile(
                    title: const Text('Linux (Flatpak)'),
                    leading: const Icon(Icons.desktop_windows_outlined),
                    onTap: () => launchURL(
                        Uri(
                          scheme: 'https',
                          host: 'flathub.org',
                          path:
                              '/apps/details/io.github.ferraridamiano.ConverterNOW',
                        ),
                        mode: LaunchMode.externalApplication),
                  ),
                  ListTile(
                    title: const Text('Linux (Snap)'),
                    leading: const Icon(Icons.desktop_windows_outlined),
                    onTap: () => launchURL(
                      Uri(
                        scheme: 'https',
                        host: 'snapcraft.io',
                        path: '/converternow',
                      ),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.sourceCode),
                    leading: const Icon(Icons.code),
                    onTap: () => launchURL(
                      Uri(
                        scheme: 'https',
                        host: 'github.com',
                        path: '/ferraridamiano/ConverterNOW',
                      ),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.translate, color: iconColor),
          title: Text(
            AppLocalizations.of(context)!.contibuteTranslating,
            style: textStyle,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          onTap: () {
            launchURL(
              Uri(
                scheme: 'https',
                host: 'github.com',
                path: '/ferraridamiano/ConverterNOW/issues/2',
              ),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
        if (!EnvironmentConfig.isPlaystore)
          ListTile(
            leading: Icon(Icons.coffee_outlined, color: iconColor),
            title: Text(
              AppLocalizations.of(context)!.buyMeACoffee,
              style: textStyle,
            ),
            shape: const RoundedRectangleBorder(borderRadius: borderRadius),
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.buyMeACoffee),
                    content: SizedBox(
                      width: 500,
                      child: Text(
                        AppLocalizations.of(context)!.donationDialog,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          AppLocalizations.of(context)!.buyMeACoffee,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          launchURL(
                            Uri(
                              scheme: 'https',
                              host: 'paypal.me',
                              path: '/DemApps',
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ListTile(
          leading: Icon(Icons.email_outlined, color: iconColor),
          title: Text(
            AppLocalizations.of(context)!.contactDeveloper,
            style: textStyle,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          onTap: () {
            launchURL(
              Uri(scheme: 'mailto', path: 'damianoferrari1998@gmail.com'),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: iconColor),
          title: Text(
            AppLocalizations.of(context)!.about,
            style: textStyle,
          ),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          onTap: () => context.goNamed('about'),
        ),
      ].map(ConstrainedContainer.new).toList()))
    ]);
  }
}
