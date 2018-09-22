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
      this.isMultiplication,
      this.coefficient,
      this.name,
      this.value});

  List<Node> leafNodes;
  bool isMultiplication;
  double coefficient;
  double value;
  String name;

  void Convert() {
    if (value == null) {
      for (Node node in leafNodes) {
        if (node.value != null) {                                               //se ha un valore
          value = node.isMultiplication
              ? node.value * node.coefficient
              : node.value / node.coefficient;                                  //metto in questo nodo il valore convertito
          _ApplyDown();                                                         //converto i nodi sottostanti
        } else {                                                                //se non c'è valore
          if (node.leafNodes != null) {
            node.Convert();
            Convert();
          }
        }
      }
    }
  }

  void _ApplyDown(){
    for(Node node in leafNodes){
      node.value=node.isMultiplication                                          //attenzione qui funziona al contrario
          ? value / node.coefficient
          : value * node.coefficient;

      if(node.leafNodes != null)
        node._ApplyDown();
    }
  }



}
