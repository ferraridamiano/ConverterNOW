import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Converter NOW"),),
      body: Center(child:
        Column(
        children: <Widget>[
          SizedBox(height: 10.0,),
          new Text("Contatta lo sviluppatore",style: TextStyle(fontSize: 22.0,color: Colors.black54),),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,

      ),)
    );
  }

}