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
     Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Chilometro Quadrato",),
     Node(isMultiplication: true, coefficientPer: 0.83612736, name: "Yard Quadrato", leafNodes: [
       Node(isMultiplication: true, coefficientPer: 3097600.0, name: "Miglio Quadrato",),
       Node(isMultiplication: true, coefficientPer: 4840.0, name: "Acri",),
     ]),
  ]);

  static Node metroc=Node(name: "Metro Cubo",leafNodes: [
    Node(isMultiplication: false, coefficientPer: 1000.0, name: "Litro",leafNodes: [
      Node(isMultiplication: true, coefficientPer: 4.54609, name: "Gallone imperiale",),
      Node(isMultiplication: true, coefficientPer: 3.785411784, name: "Gallone US",),
      Node(isMultiplication: true, coefficientPer: 0.56826125, name: "Pinta imperiale",),
      Node(isMultiplication: true, coefficientPer: 0.473176473, name: "Pinta US",),
      Node(isMultiplication: false, coefficientPer: 1000.0, name: "Millilitro", leafNodes: [
        Node(isMultiplication: true, coefficientPer: 14.8, name: "Tablespoon US",),
        Node(isMultiplication: true, coefficientPer: 20.0, name: "Australian Tablespoon",),
        Node(isMultiplication: true, coefficientPer: 240.0, name: "Cup US",),
      ]),
    ]),
    Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Centimetro Cubo", leafNodes: [
      Node(isMultiplication: true, coefficientPer: 16.387064, name: "Pollice Cubo", leafNodes: [
        Node(isMultiplication: true, coefficientPer: 1728.0, name: "Piede Cubo"),
      ]),
    ]),
    Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Millimetro Cubo",),
  ]);

  static Node secondo=Node(name: "Secondo",
      leafNodes: [
        Node(isMultiplication: false, coefficientPer: 10.0, name: "Decimo di secondo",),
        Node(isMultiplication: false, coefficientPer: 100.0, name: "Centesimo di secondo", ),
        Node(isMultiplication: false, coefficientPer: 1000.0, name: "Millisecondo",),
        Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Microsecondo",),
        Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Nanosecondo",),
        Node(isMultiplication: true, coefficientPer: 60.0, name: "Minuti",leafNodes: [
          Node(isMultiplication: true, coefficientPer: 60.0, name: "Ore",leafNodes: [
            Node(isMultiplication: true, coefficientPer: 24.0, name: "Giorni",leafNodes: [
              Node(isMultiplication: true, coefficientPer: 7.0, name: "Settimane",),
              Node(isMultiplication: true, coefficientPer: 365.0, name: "Anni (365)",leafNodes: [
                Node(isMultiplication: true, coefficientPer: 5.0, name: "Lustro",),
                Node(isMultiplication: true, coefficientPer: 10.0, name: "Decade",),
                Node(isMultiplication: true, coefficientPer: 100.0, name: "Secolo",),
                Node(isMultiplication: true, coefficientPer: 1000.0, name: "Millennio",),
              ]),
            ]),
          ]),
        ]),
      ]);

  static Node celsius=Node(name: "Fahrenheit [°F]",leafNodes:[
    Node(isMultiplication: true, coefficientPer: 1.8, isSum: true, coefficientPlus: 32.0, name: "Celsius [°C]",leafNodes: [
      Node(isSum: false, coefficientPlus: 273.15, name: "Kelvin [K]",),
    ]),
  ]);

  static Node metri_secondo=Node(name: "Metri al Secondo [m/s]", leafNodes: [
    Node(isMultiplication: false, coefficientPer: 3.6, name: "Chilometri Orari [km/h]", leafNodes:[
      Node(isMultiplication: true, coefficientPer: 1.609344, name: "Miglia orarie [mph]",),
      Node(isMultiplication: true, coefficientPer: 1.852, name: "Nodi [kts]",),
    ]),
    Node(isMultiplication: true, coefficientPer: 0.3048, name: "Piedi al secondo [ft/s]",),
  ]);


  List listaConversioni=[metro,metroq, metroc,secondo, celsius, metri_secondo];

  int _currentPage=0;

  _onSelectItem(int index) {
    if(_currentPage!=index) {
      setState(() {
        _currentPage = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: new Text("Lunghezza"),actions: <Widget>[IconButton(icon: Icon(Icons.clear,color: Colors.white,semanticLabel: 'Cancella',),)],),
      drawer: new Drawer(child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Converter PRO', style: TextStyle(color: Colors.white),),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            title: Text("Lunghezza"),
            selected: _currentPage==0,
            onTap: (){
              _onSelectItem(0);
              Navigator.of(context).pop();

            }
          ),
          ListTile(
            title: Text("Superficie"),
            selected: _currentPage==1,
            onTap:(){
              _onSelectItem(1);
              Navigator.of(context).pop();
            }

          ),
          ListTile(
            title: Text("Volume"),
            selected: _currentPage==2,
            onTap: () {
              _onSelectItem(2);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Tempo"),
            selected: _currentPage==3,
            onTap: () {
              _onSelectItem(3);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Temperatura"),
            selected: _currentPage==4,
            onTap: () {
              _onSelectItem(4);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Velocità"),
            selected: _currentPage==5,
            onTap: () {
              _onSelectItem(5);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),),
      body: ConversionPage(listaConversioni[_currentPage])
    );
  }
}
