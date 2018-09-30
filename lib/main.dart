import 'package:converter_pro/ConversionPage.dart';
import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  static Node foot=Node(isMultiplication: true, coefficient: 12.0, name: "foot", selectedNode: false, convertedNode: false);
  static Node inch=Node(isMultiplication: true, coefficient: 2.54, name: "inch", leafNodes: [foot], selectedNode: false, convertedNode: false);
  static Node millimetro=Node(isMultiplication: false, coefficient: 10.0, name: "millimetro", selectedNode: false, convertedNode: false);
  static Node centimetro=Node(isMultiplication: false, coefficient: 100.0, name: "centimetro", leafNodes: [millimetro,inch], selectedNode: true, convertedNode: true);
  static Node metro=Node(name: "metro", leafNodes: [centimetro], selectedNode: false, convertedNode: false);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM - Calculator',
      home: ConversionPage(metro),
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.indigo,
      ),
    );
  }
}