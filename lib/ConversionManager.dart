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
  List listaOrder;
  List orderLunghezza=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  List orderSuperficie=[0,1,2,3,4,5,6,7,8,9];
  List orderVolume=[0,1,2,3,4,5,6,7,8,9,10,11,12,13];
  List orderTempo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  List orderTemperatura=[0,1,2];
  List orderVelocita=[0,1,2,3,4];
  List orderPrefissi=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

  _onSelectItem(int index) {
    if(_currentPage!=index) {
      setState(() {
        _currentPage = index;
        Navigator.of(context).pop();
      });
    }
  }

  _navigateChangeOrder(BuildContext context,String title, Node nodo, Color color) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReorderPage(
            title: title,
            fatherNode: nodo,
            color:color
        ),));
    //
    List arrayCopia=new List(listaOrder[_currentPage].length);
    for(int i=0;i<listaOrder[_currentPage].length;i++)
      arrayCopia[i]=listaOrder[_currentPage][i];
    setState(() {
      for(int i=0;i<listaOrder[_currentPage].length;i++)
        listaOrder[_currentPage][i]=result.indexOf(arrayCopia[i]);
    });
  }

  @override
  Widget build(BuildContext context) {

    Node metro=Node(name: MyLocalizations.of(context).trans('metro',),order: orderLunghezza[0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centimetro'),order: orderLunghezza[1], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 2.54, name: MyLocalizations.of(context).trans('pollice'),order: orderLunghezza[2], leafNodes: [
              Node(isMultiplication: true, coefficientPer: 12.0, name: MyLocalizations.of(context).trans('piede'),order: orderLunghezza[3]),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 1852.0, name: MyLocalizations.of(context).trans('miglio_marino'),order: orderLunghezza[4],),
          Node(isMultiplication: true, coefficientPer: 0.9144, name: MyLocalizations.of(context).trans('yard'),order: orderLunghezza[5], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1760.0, name: MyLocalizations.of(context).trans('miglio_terrestre'),order: orderLunghezza[6],),
          ]),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millimetro'),order: orderLunghezza[7],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('micrometro'), order: orderLunghezza[8],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanometro'),order: orderLunghezza[9],),
          Node(isMultiplication: false, coefficientPer: 10000000000.0, name: MyLocalizations.of(context).trans('angstrom'),order: orderLunghezza[10],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: MyLocalizations.of(context).trans('picometro'),order: orderLunghezza[11],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('chilometro'),order: orderLunghezza[12],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 149597870.7, name: MyLocalizations.of(context).trans('unita_astronomica'),order: orderLunghezza[13],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 63241.1, name: MyLocalizations.of(context).trans('anno_luce'),order: orderLunghezza[14],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 3.26, name: MyLocalizations.of(context).trans('parsec'),order: orderLunghezza[15],),
              ]),
            ]),
          ]),
        ]);

    Node metroq=Node(name: MyLocalizations.of(context).trans('metro_quadrato'),order: orderSuperficie[0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('centimetro_quadrato'),order: orderSuperficie[1], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 6.4516, name: MyLocalizations.of(context).trans('pollice_quadrato'),order: orderSuperficie[2], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 144.0, name: MyLocalizations.of(context).trans('piede_quadrato'),order: orderSuperficie[3]),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('millimetro_quadrato'),order: orderSuperficie[4],),
      Node(isMultiplication: true, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('ettaro'),order: orderSuperficie[5],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('chilometro_quadrato'),order: orderSuperficie[6],),
      Node(isMultiplication: true, coefficientPer: 0.83612736, name: MyLocalizations.of(context).trans('yard_quadrato'),order: orderSuperficie[7], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 3097600.0, name: MyLocalizations.of(context).trans('miglio_quadrato'),order: orderSuperficie[8]),
        Node(isMultiplication: true, coefficientPer: 4840.0, name: MyLocalizations.of(context).trans('acri'),order: orderSuperficie[9],),
      ]),
    ]);

    Node metroc=Node(name: MyLocalizations.of(context).trans('metro_cubo'),order: orderVolume[0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('litro'),order: orderVolume[1],leafNodes: [
        Node(isMultiplication: true, coefficientPer: 4.54609, name: MyLocalizations.of(context).trans('gallone_imperiale'),order: orderVolume[2],),
        Node(isMultiplication: true, coefficientPer: 3.785411784, name: MyLocalizations.of(context).trans('gallone_us'),order: orderVolume[3],),
        Node(isMultiplication: true, coefficientPer: 0.56826125, name: MyLocalizations.of(context).trans('pinta_imperiale'),order: orderVolume[4],),
        Node(isMultiplication: true, coefficientPer: 0.473176473, name: MyLocalizations.of(context).trans('pinta_us'),order: orderVolume[5],),
        Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millilitro'),order: orderVolume[6], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 14.8, name: MyLocalizations.of(context).trans('tablespoon_us'),order: orderVolume[7],),
          Node(isMultiplication: true, coefficientPer: 20.0, name: MyLocalizations.of(context).trans('tablespoon_australian'),order:orderVolume[8],),
          Node(isMultiplication: true, coefficientPer: 240.0, name: MyLocalizations.of(context).trans('cup_us'),order: orderVolume[9],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('centimetro_cubo'),order: orderVolume[10], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 16.387064, name: MyLocalizations.of(context).trans('pollice_cubo'),order: orderVolume[11], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 1728.0, name: MyLocalizations.of(context).trans('piede_cubo'),order: orderVolume[12],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('millimetro_cubo'),order: orderVolume[13],),
    ]);

    Node secondo=Node(name: MyLocalizations.of(context).trans('secondo'),order: orderTempo[0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 10.0, name: MyLocalizations.of(context).trans('decimo_secondo'),order: orderTempo[1],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centesimo_secondo'), order: orderTempo[2],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millisecondo'),order: orderTempo[3],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('microsecondo'),order: orderTempo[4],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanosecondo'),order: orderTempo[5],),
          Node(isMultiplication: true, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('minuti'),order: orderTempo[6],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('ore'),order: orderTempo[7],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 24.0, name: MyLocalizations.of(context).trans('giorni'),order: orderTempo[8],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 7.0, name: MyLocalizations.of(context).trans('settimane'),order: orderTempo[9],),
                Node(isMultiplication: true, coefficientPer: 365.0, name: MyLocalizations.of(context).trans('anno'),order: orderTempo[10],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 5.0, name: MyLocalizations.of(context).trans('lustro'),order: orderTempo[11],),
                  Node(isMultiplication: true, coefficientPer: 10.0, name: MyLocalizations.of(context).trans('decade'),order: orderTempo[12],),
                  Node(isMultiplication: true, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('secolo'),order: orderTempo[13],),
                  Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millennio'),order: orderTempo[14],),
                ]),
              ]),
            ]),
          ]),
        ]);

    Node SI=Node(name: "Base",order: orderPrefissi[0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 10.0, name: "Deca [da]",order: orderPrefissi[1],),
          Node(isMultiplication: true, coefficientPer: 100.0, name: "Hecto [h]",order: orderPrefissi[2],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "Kilo [k]",order: orderPrefissi[3],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Mega [M]",order: orderPrefissi[4],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "Giga [G]",order: orderPrefissi[5],),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "Tera [T]",order: orderPrefissi[6],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "Peta [P]",order: orderPrefissi[7],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "Exa [E]",order: orderPrefissi[8],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000.0, name: "Zetta [Z]",order: orderPrefissi[9],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000000.0, name: "Yotta [Y]",order: orderPrefissi[10],),
          Node(isMultiplication: false, coefficientPer: 10.0, name: "Deci [d]",order: orderPrefissi[11],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: "Centi [c]",order: orderPrefissi[12],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: "Milli [m]",order: orderPrefissi[13],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Micro [µ]",order: orderPrefissi[14],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Nano [n]",order: orderPrefissi[15],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: "Pico [p]",order: orderPrefissi[16],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000.0, name: "Femto [f]",order: orderPrefissi[17],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000.0, name: "Atto  [a]",order: orderPrefissi[18],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000.0, name: "Zepto [z]",order: orderPrefissi[19],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000000.0, name: "Yocto [y]",order: orderPrefissi[20],),
        ]
    );

    Node celsius=Node(name: "Fahrenheit [°F]",order: orderTemperatura[0],leafNodes:[
      Node(isMultiplication: true, coefficientPer: 1.8, isSum: true, coefficientPlus: 32.0, name: "Celsius [°C]",order: orderTemperatura[1],leafNodes: [
        Node(isSum: false, coefficientPlus: 273.15, name: "Kelvin [K]",order: orderTemperatura[2],),
      ]),
    ]);

    Node metri_secondo=Node(name: "Metri al Secondo [m/s]", order: orderVelocita[0], leafNodes: [
      Node(isMultiplication: false, coefficientPer: 3.6, name: "Chilometri Orari [km/h]",order: orderVelocita[1], leafNodes:[
        Node(isMultiplication: true, coefficientPer: 1.609344, name: "Miglia orarie [mph]",order: orderVelocita[2],),
        Node(isMultiplication: true, coefficientPer: 1.852, name: "Nodi [kts]",order: orderVelocita[3],),
      ]),
      Node(isMultiplication: true, coefficientPer: 0.3048, name: "Piedi al secondo [ft/s]",order: orderVelocita[4],),
    ]);

    listaConversioni=[metro,metroq, metroc,secondo, celsius, metri_secondo,SI];
    listaOrder=[orderLunghezza,orderSuperficie,orderVolume,orderTempo,orderTemperatura,orderVelocita,orderPrefissi];
    listaColori=[Colors.red,Colors.deepOrange,Colors.amber,
    Colors.cyan, Colors.indigo, Colors.purple,
    Colors.blueGrey];
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
            onSelected: (Choice choice){
              _navigateChangeOrder(context, "Il mio ordinamento", listaConversioni[_currentPage], listaColori[_currentPage]);
            },
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
