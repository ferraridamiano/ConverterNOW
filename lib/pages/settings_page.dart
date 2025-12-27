import 'dart:convert';
import 'dart:io';
import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/import_export.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/palette.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translations/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const List<int> significantFiguresList = [6, 8, 10, 12, 14];
  static const BorderRadiusGeometry borderRadius = BorderRadius.all(
    Radius.circular(30),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final mapTheme = {
      ThemeMode.system.index: (
        title: l10n.system,
        icon: Icons.brightness_auto_outlined,
      ),
      ThemeMode.dark.index: (title: l10n.dark, icon: Icons.dark_mode_outlined),
      ThemeMode.light.index: (
        title: l10n.light,
        icon: Icons.light_mode_outlined
      ),
    };
    final languageTag = ref.watch(languageTagProvider).value;

    final iconColor = getIconColor(Theme.of(context));
    final titlesStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: switch (Theme.brightnessOf(context)) {
            Brightness.light => Theme.of(context).primaryColor,
            Brightness.dark => HSLColor.fromColor(
                Theme.of(context).primaryColor,
              ).withLightness(0.7).toColor(),
          },
        );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/');
        }
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar.large(title: Text(l10n.settings)),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16),
                  child: Text(
                    l10n.appearance,
                    style: titlesStyle,
                  ),
                ),
                DropdownListTile(
                  key: const ValueKey('language'),
                  leading: Icon(Icons.language, color: iconColor),
                  title: l10n.language,
                  items: [l10n.system, ...mapLocale.values],
                  value: languageTag == null
                      ? l10n.system
                      : mapLocale[languageTagToLocale(languageTag)]!,
                  onChanged: (String? string) {
                    if (string == null) return;
                    ref
                        .read(languageTagProvider.notifier)
                        .set(string == l10n.system
                            ? null
                            : mapLocale.keys
                                .firstWhere(
                                  (element) => mapLocale[element] == string,
                                )
                                .toLanguageTag());
                  },
                ),
                ListTile(
                  title: Text(l10n.themeColor),
                  leading: Icon(Icons.palette_outlined, color: iconColor),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24 / 2),
                        color: ref.watch(actualColorThemeProvider),
                      ),
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => const ColorPickerDialog(),
                  ),
                ),
                SegmentedButtonListTile(
                  leading: Icon(Icons.contrast, color: iconColor),
                  title: l10n.theme,
                  items: mapTheme.values.toList(),
                  value:
                      mapTheme[ref.watch(themeModeProvider).value ?? 0]!.title,
                  onChanged: (String? string) {
                    if (string != null) {
                      ref.read(themeModeProvider.notifier).set(
                            mapTheme.keys
                                .where((key) => mapTheme[key]?.title == string)
                                .single,
                          );
                    }
                  },
                ),
                SwitchListTile(
                  secondary: Icon(Icons.dark_mode_outlined, color: iconColor),
                  title: Text(l10n.pureBlackTheme),
                  value: ref.watch(isPureDarkProvider).value ?? false,
                  onChanged: (bool val) {
                    ref.read(isPureDarkProvider.notifier).set(val);
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                SwitchListTile(
                  secondary: Icon(Icons.apps_rounded, color: iconColor),
                  title: Text(l10n.propertySelectionOnStartup),
                  subtitle: Text(l10n.propertySelectionOnStartupSubtitle),
                  value: ref.watch(propertySelectionOnStartupProvider).value ??
                      true,
                  onChanged: (bool val) {
                    ref
                        .read(propertySelectionOnStartupProvider.notifier)
                        .set(val);
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
                  child: Text(
                    l10n.conversions,
                    style: titlesStyle,
                  ),
                ),
                if (!kIsWeb)
                  SwitchListTile(
                    secondary: Icon(Icons.public_off, color: iconColor),
                    title: Text(l10n.revokeInternetAccess),
                    value: ref.watch(revokeInternetProvider).value ?? false,
                    onChanged: (bool val) {
                      if (val) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                l10n.revokeInternetAccess,
                              ),
                              content: SizedBox(
                                width: 500,
                                child: Text(
                                  l10n.revokeInternetExplanation,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Introduce a tiny delay to let the user see the
                                    // switch to turn on
                                    Future.delayed(
                                      const Duration(milliseconds: 200),
                                      () => ref
                                          .read(
                                            revokeInternetProvider.notifier,
                                          )
                                          .set(val),
                                    );
                                  },
                                  child: Text(l10n.ok),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ref.read(revokeInternetProvider.notifier).set(val);
                        ref
                            .read(CurrenciesNotifier.provider.notifier)
                            .forceCurrenciesDownload();
                      }
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: borderRadius,
                    ),
                  ),
                SwitchListTile(
                  secondary: SvgPicture(
                    const AssetBytesLoader(
                      'assets/app_icons_opti/remove_trailing_zeros.svg.vec',
                    ),
                    width: 25,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  title: Text(l10n.removeTrailingZeros),
                  value: ref.watch(removeTrailingZerosProvider).value ?? true,
                  onChanged: (bool val) {
                    ref.read(removeTrailingZerosProvider.notifier).set(val);
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                DropdownListTile(
                  leading: SvgPicture(
                    const AssetBytesLoader(
                      'assets/app_icons_opti/significant_figures.svg.vec',
                    ),
                    width: 25,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  title: l10n.significantFigures,
                  items:
                      significantFiguresList.map((e) => e.toString()).toList(),
                  value: (ref.watch(significantFiguresProvider).value ?? 10)
                      .toString(),
                  onChanged: (String? string) {
                    if (string != null) {
                      ref
                          .read(significantFiguresProvider.notifier)
                          .set(int.parse(string));
                    }
                  },
                ),
                ListTile(
                  key: const ValueKey('reorder-properties'),
                  leading: SvgPicture(
                    const AssetBytesLoader(
                      'assets/app_icons_opti/reorder_properties.svg.vec',
                    ),
                    width: 25,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  title: Text(l10n.reorderProperties),
                  onTap: () => context.goNamed('reorder-properties'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                ListTile(
                  key: const ValueKey('reorder-units'),
                  leading: SvgPicture(
                    const AssetBytesLoader(
                      'assets/app_icons_opti/reorder_units.svg.vec',
                    ),
                    width: 25,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  title: Text(l10n.reorderUnits),
                  onTap: () => context.goNamed('reorder-units'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                ListTile(
                  key: const ValueKey('hide-units'),
                  leading: Icon(
                    Icons.visibility_off_outlined,
                    color: iconColor,
                  ),
                  title: Text(l10n.hideUnits),
                  onTap: () => context.goNamed('hide-units'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
                  child: Text(
                    l10n.backup,
                    style: titlesStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.upload_file, color: iconColor),
                  title: Text(l10n.exportSettings),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                  onTap: () async {
                    final jsonString = await ref
                        .read(ImportExportNotifier.provider.notifier)
                        .exportSettings();
                    if (kIsWeb) {
                      // Web: Trigger download
                      final bytes = utf8.encode(jsonString);
                      await FilePicker.platform.saveFile(
                        dialogTitle: l10n.exportSettings,
                        fileName: 'settings.json',
                        bytes: Uint8List.fromList(bytes),
                      );
                    } else if (Platform.isAndroid || Platform.isIOS) {
                      // Mobile: Share
                      final directory = await getTemporaryDirectory();
                      final file = File('${directory.path}/settings.json');
                      await file.writeAsString(jsonString);
                      await SharePlus.instance.share(
                        ShareParams(
                          files: [XFile(file.path)],
                          subject: 'ConverterNOW Settings',
                        ),
                      );
                    } else {
                      // Desktop: Save file
                      final outputFile = await FilePicker.platform.saveFile(
                        dialogTitle: l10n.exportSettings,
                        fileName: 'settings.json',
                      );
                      if (outputFile != null) {
                        final file = File(outputFile);
                        await file.writeAsString(jsonString);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.exportSuccess)),
                          );
                        }
                      }
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.download, color: iconColor),
                  title: Text(l10n.importSettings),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                  onTap: () async {
                    try {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['json'],
                      );

                      if (result != null) {
                        String content;
                        if (kIsWeb) {
                          final bytes = result.files.first.bytes;
                          if (bytes == null) return;
                          content = utf8.decode(bytes);
                        } else {
                          final path = result.files.single.path;
                          if (path == null) return;
                          content = await File(path).readAsString();
                        }

                        final success = await ref
                            .read(ImportExportNotifier.provider.notifier)
                            .importSettings(content);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success ? l10n.importSuccess : l10n.error,
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.error)),
                        );
                      }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16, top: 16),
                  child: Text(
                    l10n.findOutMore,
                    style: titlesStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.computer, color: iconColor),
                  title: Text(l10n.otherPlatforms),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text(l10n.otherPlatforms),
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
                              onTap: () => launchURL(
                                Uri(
                                  scheme: 'https',
                                  host: 'play.google.com',
                                  path: '/store/apps/details',
                                  queryParameters: {
                                    'id': 'com.ferrarid.converterpro',
                                  },
                                ),
                              ),
                            ),
                          if (kIsWeb || Platform.isAndroid || Platform.isLinux)
                            ListTile(
                              title: const Text('Windows'),
                              leading: const Icon(Icons.laptop),
                              onTap: () => launchURL(
                                Uri(
                                  scheme: 'https',
                                  host: 'apps.microsoft.com',
                                  path: '/detail/9p0q79hwjh72',
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
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                          ListTile(
                            title: const Text('Linux (AppImage)'),
                            leading: const Icon(Icons.desktop_windows_outlined),
                            onTap: () => launchURL(
                              Uri(
                                scheme: 'https',
                                host: 'github.com',
                                path:
                                    '/ferraridamiano/ConverterNOW/releases/latest',
                              ),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                          ListTile(
                            title: Text(l10n.sourceCode),
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
                  title: Text(l10n.contributeTranslating),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
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
                if (!const bool.fromEnvironment(
                  'IS_PLAYSTORE',
                  defaultValue: false,
                ))
                  ListTile(
                    leading: Icon(Icons.coffee_outlined, color: iconColor),
                    title: Text(l10n.buyMeACoffee),
                    shape: const RoundedRectangleBorder(
                      borderRadius: borderRadius,
                    ),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(l10n.buyMeACoffee),
                            content: SizedBox(
                              width: 500,
                              child: Text(
                                l10n.donationDialog,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  l10n.buyMeACoffee,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
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
                  leading: Icon(Icons.info_outline, color: iconColor),
                  title: Text(l10n.about),
                  shape: const RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                  onTap: () => context.goNamed('about'),
                ),
                // Space for the navigation bar (android)
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ].map(ConstrainedContainer.new).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPickerDialog extends ConsumerWidget {
  const ColorPickerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final deviceAccentColor = ref.watch(deviceAccentColorProvider);
    final colorTheme = Color(ref.watch(colorThemeProvider).value!);
    final useDeviceColor = ref.watch(useDeviceColorProvider).value!;

    return AlertDialog(
      title: Text(l10n.themeColor),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (deviceAccentColor != null) ...[
              SwitchListTile(
                value: useDeviceColor,
                onChanged: (val) =>
                    ref.read(useDeviceColorProvider.notifier).set(val),
                title: Text(l10n.useDeviceColor),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              !useDeviceColor ? l10n.pickColor : '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Center(
              child: Palette(
                initial: colorTheme,
                enabled: !useDeviceColor,
                onSelected: (color) =>
                    ref.read(colorThemeProvider.notifier).set(color.toARGB32()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
