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
                    new Text(
                      node.name,
                      style: TextStyle(
                          fontSize: 18.0,
                          //fontWeight: FontWeight.bold
                      ),
                    ),
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
  Node({
    this.leafNodes,
    this.isMultiplication=true,
    this.coefficientPer=1.0,
    this.isSum=true,
    this.coefficientPlus=0.0,
    @required this.name,
    this.value,
    this.convertedNode=false,
    this.selectedNode=false,
  });

  List<Node> leafNodes;
  bool isMultiplication;
  double coefficientPer;
  bool isSum;
  double coefficientPlus;
  double value;
  String name;
  bool convertedNode;
  bool selectedNode;

  @override
  String toString() {
    return "isMultiplication:$isMultiplication, coefficient:$coefficientPer, "
        "value:$value, name:$name, coonvertedNode:$convertedNode, selectedNode:$selectedNode";
  }

  void Convert() { //da basso a alto
    if(!convertedNode) {
      for (Node node in leafNodes) { //per ogni nodo foglia controlla se ha valore
        if (node.convertedNode) { //se ha un valore
          value = node.value == null
              ? null
              : (node.isMultiplication ? node.value * node.coefficientPer : node.value / node.coefficientPer) +
              (node.isSum ? node.coefficientPlus : -node.coefficientPlus); //metto in questo nodo il valore convertito
          convertedNode = true;
          _ApplyDown(); //converto i nodi sottostanti
        }
        else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
            node.Convert(); //ripeti la procedura
            if(node.convertedNode)
              Convert();
        }
      }
    }
    else{ //se ha valore
      for (Node node in leafNodes) {
        if(node.convertedNode==false)
          _ApplyDown();
      }
    }
  }

  void _ApplyDown(){//da alto a a basso
    for(Node node in leafNodes){
      node.value= value==null
          ? null
          : (node.isSum ? value-node.coefficientPlus : value+node.coefficientPlus)*(node.isMultiplication ? 1/node.coefficientPer : node.coefficientPer);//attenzione qui funziona al contrario
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
