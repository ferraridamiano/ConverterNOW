import 'package:converter_pro/Localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Converter NOW"),),
      body: Center(child:
        Column(
        children: <Widget>[
          SizedBox(height: 10.0,),
          new GestureDetector(
            child: new Text(MyLocalizations.of(context).trans('contatta_sviluppatore'),style: TextStyle(fontSize: 22.0,color: Colors.black54),),
            onTap: (){
              _launchURL("mailto:<damianoferrari1998@gmail.com>");
            },
          ),
          SizedBox(height: 10.0),
          new GestureDetector(
            child: new Text(MyLocalizations.of(context).trans('about'),style: TextStyle(fontSize: 22.0,color: Colors.black54),),
            onTap: (){
              showLicensePage (context: context,applicationName: MyLocalizations.of(context).trans('app_name'));
            },
          ),
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

class AboutPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title:Text(MyLocalizations.of(context).trans('about'))),
      body:new Text("This app uses the following licenses:\n"
          "Flutter plugins:\n"
          "Copyright 2017 The Chromium Authors. All rights reserved.")
    );
  }

}