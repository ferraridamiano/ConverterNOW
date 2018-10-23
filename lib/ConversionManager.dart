import 'package:converter_pro/ConversionPage.dart';
import 'package:converter_pro/Localization.dart';
import 'package:converter_pro/ReorderPage.dart';
import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Reorder', icon: Icons.reorder),
];

class ConversionManager extends StatefulWidget{
  @override
  _ConversionManager createState() => new _ConversionManager();

}

class _ConversionManager extends State<ConversionManager>{

  List listaConversioni;
  List listaColori;
  List listaTitoli;
  int _currentPage=0;

  _onSelectItem(int index) {
    if(_currentPage!=index) {
      setState(() {
        _currentPage = index;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Node metro=Node(name: MyLocalizations.of(context).trans('metro'),
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centimetro'), leafNodes: [
            Node(isMultiplication: true, coefficientPer: 2.54, name: MyLocalizations.of(context).trans('pollice'), leafNodes: [
              Node(isMultiplication: true, coefficientPer: 12.0, name: MyLocalizations.of(context).trans('piede')),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 1852.0, name: MyLocalizations.of(context).trans('miglio_marino'),),
          Node(isMultiplication: true, coefficientPer: 0.9144, name: MyLocalizations.of(context).trans('yard'), leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1760.0, name: MyLocalizations.of(context).trans('miglio_terrestre'),),
          ]),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millimetro'),),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('micrometro'), ),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanometro'),),
          Node(isMultiplication: false, coefficientPer: 10000000000.0, name: MyLocalizations.of(context).trans('angstrom'),),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: MyLocalizations.of(context).trans('picometro'),),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('chilometro'),leafNodes: [
            Node(isMultiplication: true, coefficientPer: 149597870.7, name: MyLocalizations.of(context).trans('unita_astronomica'),leafNodes: [
              Node(isMultiplication: true, coefficientPer: 63241.1, name: MyLocalizations.of(context).trans('anno_luce'),leafNodes: [
                Node(isMultiplication: true, coefficientPer: 3.26, name: MyLocalizations.of(context).trans('parsec'),),
              ]),
            ]),
          ]),
        ]);

    Node metroq=Node(name: MyLocalizations.of(context).trans('metro_quadrato'),leafNodes: [
      Node(isMultiplication: false, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('centimetro_quadrato'), leafNodes: [
        Node(isMultiplication: true, coefficientPer: 6.4516, name: MyLocalizations.of(context).trans('pollice_quadrato'), leafNodes: [
          Node(isMultiplication: true, coefficientPer: 144.0, name: MyLocalizations.of(context).trans('piede_quadrato')),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('millimetro_quadrato'),),
      Node(isMultiplication: true, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('ettaro'),),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('chilometro_quadrato'),),
      Node(isMultiplication: true, coefficientPer: 0.83612736, name: MyLocalizations.of(context).trans('yard_quadrato'), leafNodes: [
        Node(isMultiplication: true, coefficientPer: 3097600.0, name: MyLocalizations.of(context).trans('miglio_quadrato'),),
        Node(isMultiplication: true, coefficientPer: 4840.0, name: "Acri",),
      ]),
    ]);

    Node metroc=Node(name: "Metro Cubo",leafNodes: [
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

    Node secondo=Node(name: "Secondo",
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

    Node SI=Node(name: "Base",
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 10.0, name: "Deca [da]",),
          Node(isMultiplication: true, coefficientPer: 100.0, name: "Hecto [h]",),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "Kilo [k]",),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Mega [M]",),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "Giga [G]",),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "Tera [T]",),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "Peta [P]",),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "Exa [E]",),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000.0, name: "Zetta [Z]",),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000000.0, name: "Yotta [Y]",),
          Node(isMultiplication: false, coefficientPer: 10.0, name: "Deci [d]",),
          Node(isMultiplication: false, coefficientPer: 100.0, name: "Centi [c]",),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: "Milli [m]",),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Micro [µ]",),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Nano [n]",),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: "Pico [p]",),
          Node(isMultiplication: false, coefficientPer: 1000000000000000.0, name: "Femto [f]",),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000.0, name: "Atto  [a]",),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000.0, name: "Zepto [z]",),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000000.0, name: "Yocto [y]",),
        ]
    );

    Node celsius=Node(name: "Fahrenheit [°F]",leafNodes:[
      Node(isMultiplication: true, coefficientPer: 1.8, isSum: true, coefficientPlus: 32.0, name: "Celsius [°C]",leafNodes: [
        Node(isSum: false, coefficientPlus: 273.15, name: "Kelvin [K]",),
      ]),
    ]);

    Node metri_secondo=Node(name: "Metri al Secondo [m/s]", leafNodes: [
      Node(isMultiplication: false, coefficientPer: 3.6, name: "Chilometri Orari [km/h]", leafNodes:[
        Node(isMultiplication: true, coefficientPer: 1.609344, name: "Miglia orarie [mph]",),
        Node(isMultiplication: true, coefficientPer: 1.852, name: "Nodi [kts]",),
      ]),
      Node(isMultiplication: true, coefficientPer: 0.3048, name: "Piedi al secondo [ft/s]",),
    ]);

    listaConversioni=[metro,metroq, metroc,secondo, celsius, metri_secondo,SI];
    listaColori=[Colors.red,Colors.deepOrange,Colors.amber,Colors.cyan, Colors.indigo, Colors.purple, Colors.blueGrey];
    listaTitoli=[MyLocalizations.of(context).trans('lunghezza'),MyLocalizations.of(context).trans('superficie'),MyLocalizations.of(context).trans('volume'),
    MyLocalizations.of(context).trans('tempo'),MyLocalizations.of(context).trans('temperatura'),MyLocalizations.of(context).trans('velocita'),
    MyLocalizations.of(context).trans('prefissi_si')];

    return Scaffold(
      appBar: AppBar(
        title: new Text(listaTitoli[_currentPage]),
        backgroundColor: listaColori[_currentPage],
        actions: <Widget>[
          IconButton(icon: Icon(Icons.clear,color: Colors.white,semanticLabel: 'Clear all',),
            onPressed: () {
              setState(() {
                listaConversioni[_currentPage].ClearAllValues();
              });
            },),
          PopupMenuButton<Choice>(
            onSelected: (Choice choice){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReorderPage(
                title: "Il mio ordinamento",
                listaNodi: listaConversioni[_currentPage].getNodiFiglio(),
                color:listaColori[_currentPage]
              )),
            );},
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: new Drawer(child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Image.asset("resources/images/logo.png"),
            ),
            decoration: BoxDecoration(color: listaColori[_currentPage],),
          ),
            /*child: Align(
              child:Text('Converter PRO', style: TextStyle(color: Colors.white),),
              alignment: FractionalOffset.bottomLeft,
            ),
            
            decoration: BoxDecoration(
              color: listaColori[_currentPage],
              image: DecorationImage(image: AssetImage("resources/images/logo.png"),fit: BoxFit.fitHeight),


            ),*/
          ListTile(
            title: Text(listaTitoli[0]),
            selected: _currentPage==0,
            onTap: (){
              _onSelectItem(0);
            }
          ),
          ListTile(
            title: Text(listaTitoli[1]),
            selected: _currentPage==1,
            onTap:(){
              _onSelectItem(1);
            }

          ),
          ListTile(
            title: Text(listaTitoli[2]),
            selected: _currentPage==2,
            onTap: () {
              _onSelectItem(2);
            },
          ),
          ListTile(
            title: Text(listaTitoli[3]),
            selected: _currentPage==3,
            onTap: () {
              _onSelectItem(3);
            },
          ),
          ListTile(
            title: Text(listaTitoli[4]),
            selected: _currentPage==4,
            onTap: () {
              _onSelectItem(4);
            },
          ),
          ListTile(
            title: Text(listaTitoli[5]),
            selected: _currentPage==5,
            onTap: () {
              _onSelectItem(5);
            },
          ),
          ListTile(
            title: Text(listaTitoli[6]),
            selected: _currentPage==6,
            onTap: () {
              _onSelectItem(6);
            },
          ),
        ],
      ),),
      body: ConversionPage(listaConversioni[_currentPage]),

    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}