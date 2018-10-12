import 'package:converter_pro/ConversionPage.dart';
import 'package:converter_pro/Utils.dart';
import 'package:converter_pro/firstFragment.dart';
import 'package:flutter/material.dart';

class ConversionManager extends StatefulWidget{
  @override
  _ConversionManager createState() => new _ConversionManager();

}

class _ConversionManager extends State<ConversionManager>{
  static Node metro=Node(name: "Metro",
      leafNodes: [
        Node(isMultiplication: false, coefficientPer: 100.0, name: "Centimetro", leafNodes: [
          Node(isMultiplication: true, coefficientPer: 2.54, name: "Pollice", leafNodes: [
            Node(isMultiplication: true, coefficientPer: 12.0, name: "Piede"),
          ]),
        ]),
        Node(isMultiplication: true, coefficientPer: 1852.0, name: "Miglio Marino",),
        Node(isMultiplication: true, coefficientPer: 0.9144, name: "Yard", leafNodes: [
          Node(isMultiplication: true, coefficientPer: 1760.0, name: "Miglio Terrestre",),
        ]),
        Node(isMultiplication: false, coefficientPer: 1000.0, name: "Millimetro",),
        Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Micrometro", ),
        Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Nanometro",),
        Node(isMultiplication: false, coefficientPer: 10000000000.0, name: "Ångström",),
        Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: "Picometro",),
        Node(isMultiplication: true, coefficientPer: 1000.0, name: "Chilometro",leafNodes: [
          Node(isMultiplication: true, coefficientPer: 149597870.7, name: "Unità Astronomica",leafNodes: [
            Node(isMultiplication: true, coefficientPer: 63241.1, name: "Anno Luce",leafNodes: [
              Node(isMultiplication: true, coefficientPer: 3.26, name: "Parsec",),
            ]),
          ]),
        ]),
  ]);

   static Node metroq=Node(name: "Metro Quadrato",leafNodes: [
     Node(isMultiplication: false, coefficientPer: 10000.0, name: "Centimetro Quadrato", leafNodes: [
       Node(isMultiplication: true, coefficientPer: 6.4516, name: "Pollice Quadrato", leafNodes: [
         Node(isMultiplication: true, coefficientPer: 144.0, name: "Piede Quadrato"),
       ]),
     ]),
     Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Millimetro Quadrato",),
     Node(isMultiplication: true, coefficientPer: 10000.0, name: "Ettaro [He]",),
     Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Chilometro quadrato",),
     Node(isMultiplication: true, coefficientPer: 0.83612736, name: "Yard quadrata", leafNodes: [
       Node(isMultiplication: true, coefficientPer: 3097600.0, name: "Miglio quadrato",),
       Node(isMultiplication: true, coefficientPer: 4840.0, name: "Acri",),
     ]),

   ]);

   List listaConversioni=[metro,metroq];

  int _currentPage=0;

  _onSelectItem(int index) {
    setState((){
      _currentPage = index;
    });
    //Navigator.of(context).pop(); // close the drawer
  }

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
            selected: _currentPage==0,
            onTap: (){
              if(_currentPage!=0)
                _onSelectItem(0);
              Navigator.of(context).pop();

            }
          ),
          ListTile(
            title: Text("Superficie"),
            selected: _currentPage==1,
            onTap:(){
              if(_currentPage!=1)
                _onSelectItem(1);
              Navigator.of(context).pop();
            }

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
      body: ConversionPage(listaConversioni[_currentPage])
    );
  }
}
