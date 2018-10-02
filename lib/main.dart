import 'package:converter_pro/ConversionManager.dart';
import 'package:flutter/material.dart';

void main() => runApp(new App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM - Calculator',
      home: ConversionManager(),
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.indigo,
      ),
    );
  }
}