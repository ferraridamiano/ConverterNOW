import 'package:converter_pro/Localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          color: Colors.red,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: () {Navigator.pop(context);},),
            ],
          ),
        ),
      body: Center(child:
        Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new GestureDetector(
            child: new Text(MyLocalizations.of(context).trans('recensione'),style: TextStyle(fontSize: 28.0,color: Colors.black54),),
            onTap: (){
              _launchURL("https://play.google.com/store/apps/details?id=com.ferrarid.converterpro");
            },
          ),
          SizedBox(height: 20.0),
          new GestureDetector(
            child: new Text(MyLocalizations.of(context).trans('contatta_sviluppatore'),style: TextStyle(fontSize: 28.0,color: Colors.black54),),
            onTap: (){
              _launchURL("mailto:<damianoferrari1998@gmail.com>");
            },
          ),
          SizedBox(height: 20.0),
          new GestureDetector(
            child: new Text(MyLocalizations.of(context).trans('about'),style: TextStyle(fontSize: 28.0,color: Colors.black54),),
            onTap: (){
              showLicensePage (context: context,applicationName: MyLocalizations.of(context).trans('app_name'),
                  applicationLegalese: "Icons made by https://www.flaticon.com/authors/yannick Yannick from https://www.flaticon.com/ www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n"+ //termometro
                                       "Icons made by http://www.freepik.com Freepik from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY\n" +//lunghezza, velocità, pressione, area, energia, massa
                                       "Icons made by https://www.flaticon.com/authors/bogdan-rosu Bogdan Rosu from https://www.flaticon.com/ Flaticon www.flaticon.com is licensed by http://creativecommons.org/licenses/by/3.0/ Creative Commons BY 3.0 CC 3.0 BY" //volume

              );
            },
          ),
          SizedBox(height: 20.0,),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,

      ),)
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}