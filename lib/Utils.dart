import 'package:flutter/material.dart';

class UnitCard extends StatelessWidget {
  UnitCard({this.title, this.textField});

  final Widget title;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(bottom: 5.0),
        child: new Card(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    this.title,
                    new SizedBox(
                      width: 20.0,
                    ),
                    this.textField
                  ])),
          elevation: 4.0,
        ));
  }
}

class Node {
  Node(
      {this.leafNodes,
      @required this.isMultiplication,
      @required this.coefficient,
      @required this.name,
      this.value,
      this.convertedNode=false,
      this.selectedNode=false});

  List<Node> leafNodes;
  bool isMultiplication;
  double coefficient;
  double value;
  String name;
  bool convertedNode;
  bool selectedNode;

  void Convert() { //da basso a alto
    if (value == null) {
      for (Node node in leafNodes) {
        if (node.convertedNode) {                                               //se ha un valore
          value = node.isMultiplication
              ? node.value * node.coefficient
              : node.value / node.coefficient;                                  //metto in questo nodo il valore convertito
          convertedNode=true;
          _ApplyDown();                                                         //converto i nodi sottostanti
        } else {                                                                //se non c'è valore
          if (node.leafNodes != null) {                                         //se ha almeno un nodo foglia
            node.Convert();
            Convert();
          }
        }
      }
    }
  }

  void _ApplyDown(){//da alto a a basso
    for(Node node in leafNodes){
      node.value=node.isMultiplication                                          //attenzione qui funziona al contrario
          ? value / node.coefficient
          : value * node.coefficient;
      node.convertedNode=true;

      if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
        node._ApplyDown();
    }
  }

  /**
   * Resetta convertedNode su false per i nodi non selezionati dall'alto al basso (bisogna quindi chiamarlo dal nodo padre)
   */
  void ResetConvertedNode(){
    if(!selectedNode)                                                           //se non è il nodo selezionato
      convertedNode=false;                                                      //resetto il fatto che il nodo sia già stato convertito
    if(leafNodes!=null) {
      for (Node node in leafNodes) { //per ogni nodo dell'albero
        node.ResetConvertedNode();
      }
    }
  }

  List<Node> getNodiFiglio(){

    List<Node> listaNodi=[this];

    if(leafNodes != null){
      for(Node node in leafNodes) {
        listaNodi.addAll(node.getNodiFiglio());
      }
    }
    return listaNodi;

  }



}
