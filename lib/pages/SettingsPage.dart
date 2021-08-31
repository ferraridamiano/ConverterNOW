import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/styles/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as Math;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> significantFiguresList = [];
  bool removeTrailingZeros = true;
  int significantFigures = 10;
  TextStyle textStyle = TextStyle(fontSize: SINGLE_PAGE_TEXT_SIZE);
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

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: new Stack(
          children: <Widget>[
            Container(
              height: 48.0,
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: AppLocalizations.of(context)!.back,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 48.0,
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: Math.max(0, (MediaQuery.of(context).size.width - SINGLE_PAGE_FIXED_HEIGHT) / 2),
          ),
          reverse: true,
          children: [
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
            DropdownListTile(
              title: AppLocalizations.of(context)!.language,
              textStyle: textStyle,
              items: [
                AppLocalizations.of(context)!.system,
                ...context.read<AppModel>().mapLocale.values.toList(),
              ],
              value: locale ?? AppLocalizations.of(context)!.system,
              onChanged: (String? string) {
                setState(() => {
                  locale = string == AppLocalizations.of(context)!.system ? null : string
                });
                context.read<AppModel>().setLocaleString(string == AppLocalizations.of(context)!.system ? null : string);
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
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.amoledDarkTheme,
                style: textStyle,
              ),
              value: isDarkAmoled,
              activeColor: Theme.of(context).accentColor,
              onChanged: (bool val) {
                setState(() => isDarkAmoled = val);
                AppModel appModel = context.read<AppModel>();
                appModel.isDarkAmoled = val;
              },
            ),
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context)!.removeTrailingZeros,
                style: textStyle,
              ),
              value: removeTrailingZeros,
              activeColor: Theme.of(context).accentColor,
              onChanged: (bool val) {
                setState(() => removeTrailingZeros = val);
                Conversions conversions = context.read<Conversions>();
                conversions.removeTrailingZeros = val;
              },
            ),
            !kIsWeb
                ? ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.rateApp,
                      style: textStyle,
                    ),
                    onTap: () {
                      launchURL("https://play.google.com/store/apps/details?id=com.ferrarid.converterpro");
                    },
                  )
                : SizedBox(),
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
                AppLocalizations.of(context)!.repoGithub,
                style: textStyle,
              ),
              onTap: () {
                launchURL("https://github.com/ferraridamiano/ConverterNOW");
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
                        style: TextStyle(fontSize: 18),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!.buyMeACoffee,
                            style: TextStyle(color: Theme.of(context).accentColor),
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
            !kIsWeb
                ? ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.contactDeveloper,
                      style: textStyle,
                    ),
                    onTap: () {
                      launchURL("mailto:<damianoferrari1998@gmail.com>");
                    },
                  )
                : SizedBox(),
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
                        "Icons made by https://www.flaticon.com/authors/yannick Yannick from https://www.flaticon.com/ www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n" + //termometro
                            "Icons made by http://www.freepik.com Freepik from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n" + //lunghezza, velocità, pressione, area, energia, massa
                            "Icons made by https://www.flaticon.com/authors/bogdan-rosu Bogdan Rosu from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY"); //volume
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownListTile extends StatelessWidget {
  final String title;
  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;
  final TextStyle textStyle;

  DropdownListTile({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: textStyle,
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((String item) {
            return Center(
                child: Text(
              item,
              style: textStyle,
            ));
          }).toList();
        },
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            child: Text(
              item.toString(),
              style: textStyle,
            ),
            value: item,
          );
        }).toList(),
      ),
    );
  }
}
