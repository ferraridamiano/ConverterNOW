import 'package:converter_pro/ConversionPage.dart';
import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

class ConversionManager extends StatefulWidget{
  @override
  _ConversionManager createState() => new _ConversionManager();

}

class _ConversionManager extends State<ConversionManager>{
   static Node metro=Node(name: "Metro",
      leafNodes: [
        Node(isMultiplication: false, coefficient: 1000.0, name: "Millimetro",),
        Node(isMultiplication: false, coefficient: 1000000.0, name: "Micrometro", ),
        Node(isMultiplication: false, coefficient: 1000000000.0, name: "Nanometro",),
        Node(isMultiplication: true, coefficient: 1000.0, name: "Chilometro",leafNodes: [
          Node(isMultiplication: true, coefficient: 149597870.7, name: "Unità Astronomica",leafNodes: [
            Node(isMultiplication: true, coefficient: 63241.1, name: "Anno Luce",),
          ]),
        ]),
        Node(isMultiplication: false, coefficient: 100.0, name: "Centimetro", leafNodes: [
          Node(isMultiplication: true, coefficient: 2.54, name: "Pollice", leafNodes: [
            Node(isMultiplication: true, coefficient: 12.0, name: "Piede"),
          ]),
        ]),

  ]
  );


  int currentPage=0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: new Text("Lunghezza"),),
      drawer: new Drawer(child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Converter PRO'),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            title: Text("Lunghezza"),
            selected: true,
            onTap: () {
              if(currentPage!=0) {
                setState((){
                  currentPage=0;
                });
              }
            },
          ),
          ListTile(
            title: Text("Superficie"),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text("Volume"),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text("Tempo"),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text("Temperatura"),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
        ],
      ),),
      body: currentPage==0 ? ConversionPage(metro) : ConversionPage(metro)
    );
  }
}
