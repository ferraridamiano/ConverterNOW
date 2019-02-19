import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

class ConversionBaseNumerica extends StatefulWidget{
  @override
  _ConversionBaseNumerica createState() => new _ConversionBaseNumerica();
}

class _ConversionBaseNumerica extends State<ConversionBaseNumerica>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("ciao"),),
      body: Column(
      children: <Widget>[
        Text(decToBase(60,8),),
        Text(basetoDec("4375",8),)
      ],)
      
      );
  }
}