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
  List<String> significantFiguresList;
  bool isLogoVisible;
  bool removeTrailingZeros;
  int significantFigures;
  TextStyle textStyle = TextStyle(fontSize: SINGLE_PAGE_TEXT_SIZE);
  ThemeMode currentTheme;
  bool isDarkAmoled;

  @override
  void initState() {
    super.initState();
    Conversions conversions = context.read<Conversions>();
    isLogoVisible = context.read<AppModel>().isLogoVisible;
    removeTrailingZeros = conversions.removeTrailingZeros;
    significantFigures = conversions.significantFigures;
    significantFiguresList = [];
    for (int value in conversions.significantFiguresList) {
      significantFiguresList.add(value.toString());
    }
    AppModel appModel = context.read<AppModel>();
    currentTheme = appModel.currentThemeMode;
    isDarkAmoled = appModel.isDarkAmoled;
  }

  @override
  Widget build(BuildContext context) {
    Map<ThemeMode, String> mapTheme = {
      ThemeMode.system: AppLocalizations.of(context).system,
      ThemeMode.dark: AppLocalizations.of(context).dark,
      ThemeMode.light: AppLocalizations.of(context).light,
    };

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: new Stack(
          children: <Widget>[
            IconButton(
              tooltip: AppLocalizations.of(context).back,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
                child: Text(
                  AppLocalizations.of(context).settings,
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                height: 48.0,
                alignment: Alignment.center)
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
              title: AppLocalizations.of(context).significantFigures,
              textStyle: textStyle,
              items: significantFiguresList,
              value: significantFigures.toString(),
              onChanged: (String string) {
                int val = int.parse(string);
                setState(() => significantFigures = val);
                Conversions conversions = context.read<Conversions>();
                conversions.significantFigures = val;
              },
            ),
            DropdownListTile(
              title: AppLocalizations.of(context).theme,
              textStyle: textStyle,
              items: mapTheme.values.toList(),
              value: mapTheme[currentTheme],
              onChanged: (String string) {
                setState(() => currentTheme = mapTheme.keys.where((key) => mapTheme[key] == string).single);
                AppModel appModel = context.read<AppModel>();
                appModel.currentThemeMode = currentTheme;
              },
            ),
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context).amoledDarkTheme,
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
                AppLocalizations.of(context).drawerLogo,
                style: textStyle,
              ),
              value: isLogoVisible,
              activeColor: Theme.of(context).accentColor,
              onChanged: (bool val) {
                setState(() => isLogoVisible = val);
                AppModel appModel = context.read<AppModel>();
                appModel.isLogoVisible = val;
              },
            ),
            SwitchListTile(
              title: Text(
                AppLocalizations.of(context).removeTrailingZeros,
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
                      AppLocalizations.of(context).rateApp,
                      style: textStyle,
                    ),
                    onTap: () {
                      launchURL("https://play.google.com/store/apps/details?id=com.ferrarid.converterpro");
                    },
                  )
                : SizedBox(),
            ListTile(
              title: Text(
                AppLocalizations.of(context).contibuteTranslating,
                style: textStyle,
              ),
              onTap: () {
                launchURL("https://github.com/ferraridamiano/ConverterNOW/issues/2");
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).repoGithub,
                style: textStyle,
              ),
              onTap: () {
                launchURL("https://github.com/ferraridamiano/ConverterNOW");
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).donation,
                style: textStyle,
              ),
              onTap: () {
                launchURL("https://www.paypal.me/DemApps");
              },
            ),
            !kIsWeb
                ? ListTile(
                    title: Text(
                      AppLocalizations.of(context).contactDeveloper,
                      style: textStyle,
                    ),
                    onTap: () {
                      launchURL("mailto:<damianoferrari1998@gmail.com>");
                    },
                  )
                : SizedBox(),
            ListTile(
              title: Text(
                AppLocalizations.of(context).about,
                style: textStyle,
              ),
              onTap: () {
                showLicensePage(
                    context: context,
                    applicationName: AppLocalizations.of(context).appName,
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
  final ValueChanged<String> onChanged;
  final TextStyle textStyle;

  DropdownListTile({this.title, this.items, this.value, this.onChanged, this.textStyle});

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
