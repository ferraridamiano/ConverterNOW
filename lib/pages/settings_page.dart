import 'dart:io';
import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/app_model.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final bool isDrawerFixed;

  const SettingsPage({this.isDrawerFixed = true, Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> significantFiguresList = [];
  bool removeTrailingZeros = true;
  int significantFigures = 10;
  static const TextStyle textStyle = TextStyle(fontSize: singlePageTextSize);
  ThemeMode currentTheme = ThemeMode.system;
  bool isDarkAmoled = false;
  String? locale;

  @override
  void initState() {
    super.initState();
    Conversions conversions = context.read<Conversions>();
    removeTrailingZeros = conversions.removeTrailingZeros;
    significantFigures = conversions.significantFigures;
    for (int value in conversions.significantFiguresList) {
      significantFiguresList.add(value.toString());
    }
    AppModel appModel = context.read<AppModel>();
    currentTheme = appModel.currentThemeMode;
    isDarkAmoled = appModel.isDarkAmoled;
    locale = appModel.mapLocale[appModel.appLocale];
  }

  @override
  Widget build(BuildContext context) {
    Map<ThemeMode, String> mapTheme = {
      ThemeMode.system: AppLocalizations.of(context)!.system,
      ThemeMode.dark: AppLocalizations.of(context)!.dark,
      ThemeMode.light: AppLocalizations.of(context)!.light,
    };

    return Expanded(
      child: Column(
        children: [
          BigTitle(
            text: AppLocalizations.of(context)!.settings,
            center: true,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: responsivePadding(MediaQuery.of(context).size.width),
              ),
              children: [
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.removeTrailingZeros,
                    style: textStyle,
                  ),
                  value: removeTrailingZeros,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (bool val) {
                    setState(() => removeTrailingZeros = val);
                    Conversions conversions = context.read<Conversions>();
                    conversions.removeTrailingZeros = val;
                  },
                ),
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.amoledDarkTheme,
                    style: textStyle,
                  ),
                  value: isDarkAmoled,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (bool val) {
                    setState(() => isDarkAmoled = val);
                    AppModel appModel = context.read<AppModel>();
                    appModel.isDarkAmoled = val;
                  },
                ),
                DropdownListTile(
                  title: AppLocalizations.of(context)!.theme,
                  textStyle: textStyle,
                  items: mapTheme.values.toList(),
                  value: mapTheme[currentTheme]!,
                  onChanged: (String? string) {
                    setState(() => currentTheme = mapTheme.keys.where((key) => mapTheme[key] == string).single);
                    AppModel appModel = context.read<AppModel>();
                    appModel.currentThemeMode = currentTheme;
                  },
                ),
                DropdownListTile(
                  title: AppLocalizations.of(context)!.language,
                  textStyle: textStyle,
                  items: [
                    AppLocalizations.of(context)!.system,
                    ...context.read<AppModel>().mapLocale.values.toList(),
                  ],
                  value: locale ?? AppLocalizations.of(context)!.system,
                  onChanged: (String? string) {
                    setState(() => {locale = string == AppLocalizations.of(context)!.system ? null : string});
                    context
                        .read<AppModel>()
                        .setLocaleString(string == AppLocalizations.of(context)!.system ? null : string);
                  },
                ),
                DropdownListTile(
                  title: AppLocalizations.of(context)!.significantFigures,
                  textStyle: textStyle,
                  items: significantFiguresList,
                  value: significantFigures.toString(),
                  onChanged: (String? string) {
                    if (string != null) {
                      int val = int.parse(string);
                      setState(() => significantFigures = val);
                      Conversions conversions = context.read<Conversions>();
                      conversions.significantFigures = val;
                    }
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.reorderProperties,
                    style: textStyle,
                  ),
                  onTap: () => context.read<AppModel>().currentScreen = MAIN_SCREEN.reorderProperties,
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.reorderUnits,
                    style: textStyle,
                  ),
                  onTap: () => context.read<AppModel>().currentScreen = MAIN_SCREEN.reorderUnits,
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.otherPlatforms,
                    style: textStyle,
                  ),
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
                              onTap: () => launchURL("https://ferraridamiano.github.io/ConverterNOW"),
                            ),
                          if (kIsWeb || Platform.isWindows || Platform.isLinux)
                            ListTile(
                              title: const Text('Android'),
                              leading: const Icon(Icons.android_outlined),
                              onTap: () =>
                                  launchURL("https://play.google.com/store/apps/details?id=com.ferrarid.converterpro"),
                            ),
                          if (kIsWeb || Platform.isAndroid || Platform.isLinux)
                            ListTile(
                              title: const Text('Windows'),
                              leading: const Icon(Icons.laptop),
                              onTap: () => launchURL("https://github.com/ferraridamiano/ConverterNOW/releases"),
                            ),
                          if (kIsWeb || Platform.isAndroid || Platform.isWindows)
                            ListTile(
                              title: const Text('Linux'),
                              leading: Image.asset(
                                'resources/images/penguin.png',
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.black54,
                                width: 25,
                              ),
                              onTap: () => launchURL("https://snapcraft.io/converternow"),
                            ),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.sourceCode),
                            leading: Image.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 'resources/images/github_light.png'
                                  : 'resources/images/github_dark.png',
                              width: 25,
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : null,
                              filterQuality: FilterQuality.medium,
                            ),
                            onTap: () => launchURL("https://github.com/ferraridamiano/ConverterNOW"),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.contibuteTranslating,
                    style: textStyle,
                  ),
                  onTap: () {
                    launchURL("https://github.com/ferraridamiano/ConverterNOW/issues/2");
                  },
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.buyMeACoffee,
                    style: textStyle,
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.buyMeACoffee),
                          content: Text(
                            AppLocalizations.of(context)!.donationDialog,
                            style: const TextStyle(fontSize: 18),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                AppLocalizations.of(context)!.buyMeACoffee,
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                launchURL('https://www.buymeacoffee.com/ferraridamiano');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                if (!kIsWeb)
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.contactDeveloper,
                      style: textStyle,
                    ),
                    onTap: () {
                      launchURL("mailto:<damianoferrari1998@gmail.com>");
                    },
                  ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.about,
                    style: textStyle,
                  ),
                  onTap: () {
                    showLicensePage(
                        context: context,
                        applicationName: AppLocalizations.of(context)!.appName,
                        applicationLegalese:
                            'Icons made by https://www.flaticon.com/authors/yannick Yannick from https://www.flaticon.com/ www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n' //termometro
                            'Icons made by http://www.freepik.com Freepik from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n' //lunghezza, velocità, pressione, area, energia, massa
                            'Icons made by https://www.flaticon.com/authors/bogdan-rosu Bogdan Rosu from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY'); //volume
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
