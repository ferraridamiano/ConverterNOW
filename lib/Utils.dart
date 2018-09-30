import 'package:flutter/material.dart';

class UnitCard extends StatelessWidget {
  UnitCard({this.node, this.textField});

  Node node;
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
                    new Text(node.name, style: TextStyle(fontSize: 16.0),),
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
      this.selectedNode=false,
      this.isFather=false});

  List<Node> leafNodes;
  bool isMultiplication;
  double coefficient;
  double value;
  String name;
  bool convertedNode;
  bool selectedNode;
  final bool isFather;

  @override
  String toString() {
    return "isMultiplication:$isMultiplication, coefficient:$coefficient, "
        "value:$value, name:$name, coonvertedNode:$convertedNode, selectedNode:$selectedNode";
  }

  void Convert() { //da basso a alto
    if (!convertedNode) {
      for (Node node in leafNodes) {
        if (node.convertedNode) {                                               //se ha un valore
          value = node.value==null
              ? null
              : (node.isMultiplication ? node.value * node.coefficient : node.value / node.coefficient);                                  //metto in questo nodo il valore convertito
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
      node.value= value==null
          ? null
          : (node.isMultiplication ? value / node.coefficient : value * node.coefficient);//attenzione qui funziona al contrario
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
