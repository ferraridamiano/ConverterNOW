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
  List<int> significantFiguresList;
  bool isLogoVisible;
  bool removeTrailingZeros;
  int significantFigures;
  TextStyle textStyle = TextStyle(fontSize: SINGLE_PAGE_TEXT_SIZE);

  @override
  void initState() {
    super.initState();
    Conversions conversions = context.read<Conversions>();
    isLogoVisible = context.read<AppModel>().isLogoVisible;
    removeTrailingZeros = conversions.removeTrailingZeros;
    significantFigures = conversions.significantFigures;
    significantFiguresList = conversions.significantFiguresList;
  }

  @override
  Widget build(BuildContext context) {
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
            ListTile(
              title: Text(
                AppLocalizations.of(context).significantFigures,
                style: textStyle,
              ),
              trailing: DropdownButton<String>(
                value: significantFigures.toString(),
                onChanged: (String string) {
                  int val = int.parse(string);
                  setState(() => significantFigures = val);
                  Conversions conversions = context.read<Conversions>();
                  conversions.significantFigures = val;
                },
                selectedItemBuilder: (BuildContext context) {
                  return significantFiguresList.map<Widget>((int item) {
                    return Center(
                        child: Text(
                      item.toString(),
                      style: textStyle,
                    ));
                  }).toList();
                },
                items: significantFiguresList.map((int item) {
                  return DropdownMenuItem<String>(
                    child: Text(
                      item.toString(),
                      style: textStyle,
                    ),
                    value: item.toString(),
                  );
                }).toList(),
              ),
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
