import 'package:converterpro/utils/Localization.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  final Color primaryColor;
  final Color accentColor;
  SettingsPage(this.primaryColor, this.accentColor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: primaryColor,
          child: new Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                  child: Text(MyLocalizations.of(context).trans('menu'),
                      style: TextStyle(fontSize: 25.0, color: Colors.white)),
                  height: 48.0,
                  alignment: Alignment.center)
            ],
          ),
        ),
        body: Center(
            child: ListView(
          reverse: true,
          children: [
            !kIsWeb? SettingsListTile(
              title: MyLocalizations.of(context).trans('recensione'),
              onTap: () {
                      launchURL("https://play.google.com/store/apps/details?id=com.ferrarid.converterpro");
              }
            ): SizedBox(),
            SettingsListTile(
              title: MyLocalizations.of(context).trans('traduzione_app'),
              onTap: () {
                launchURL(
                    "https://github.com/ferraridamiano/ConverterNOW/issues/2");
              }
            ),
            SettingsListTile(
              title: MyLocalizations.of(context).trans('repo_github'),
              onTap: () {
                launchURL("https://github.com/ferraridamiano/ConverterNOW");
              }
            ),
            SettingsListTile(
              title: MyLocalizations.of(context).trans('donazione'),
              onTap: () {
                launchURL("https://www.paypal.me/DemApps");
              },
            ),
            !kIsWeb? SettingsListTile(
                title: MyLocalizations.of(context).trans('contatta_sviluppatore'),
                onTap: () {
                  launchURL("mailto:<damianoferrari1998@gmail.com>");
            }) : SizedBox(),
            SettingsListTile(
                title: MyLocalizations.of(context).trans('about'),
                onTap: () {
                  showLicensePage(
                      context: context,
                      applicationName:
                          MyLocalizations.of(context).trans('app_name'),
                      applicationLegalese:
                          "Icons made by https://www.flaticon.com/authors/yannick Yannick from https://www.flaticon.com/ www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n" + //termometro
                              "Icons made by http://www.freepik.com Freepik from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n" + //lunghezza, velocità, pressione, area, energia, massa
                              "Icons made by https://www.flaticon.com/authors/bogdan-rosu Bogdan Rosu from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY"); //volume
            }),
            SettingsListTile(
                title: MyLocalizations.of(context).trans('impostazioni'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsPage2(primaryColor, accentColor)),
                  );
                }),
          ],
        )));
  }
}

class SettingsListTile extends StatelessWidget {
  final String title;
  final Function onTap;
  SettingsListTile({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
          child: Text(
        title,
        style: TextStyle(
            fontSize: 24.0,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Color(0xFFCCCCCC)
                : Colors.black54),
      )),
      onTap: () {
        onTap();
      },
    );
  }
}

class SettingsPage2 extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;

  SettingsPage2(this.primaryColor, this.accentColor);

  @override
  _SettingsPage2 createState() => _SettingsPage2();
}

class _SettingsPage2 extends State<SettingsPage2> {
  bool value1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: widget.primaryColor,
          child: new Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                  child: Text(MyLocalizations.of(context).trans('impostazioni'),
                      style: TextStyle(fontSize: 25.0, color: Colors.white)),
                  height: 48.0,
                  alignment: Alignment.center)
            ],
          ),
        ),
        body: Align(
            alignment: Alignment.bottomCenter,
            child: ListView(reverse: true, children: <Widget>[
              CheckboxListTile(
                title: Text(MyLocalizations.of(context).trans('logo_drawer')),
                value: isLogoVisible,
                activeColor: widget.accentColor,
                onChanged: (bool val) {
                  setState(() {
                    isLogoVisible = val;
                    prefs.setBool("isLogoVisible", isLogoVisible);
                  });
                },
              ),
            ])));
  }
}
