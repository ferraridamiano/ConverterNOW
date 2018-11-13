import 'package:flutter/material.dart';
import 'dart:math';

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
    this.name,
    this.value,
    this.convertedNode=false,
    this.selectedNode=false,
    @required this.order
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
  int order;

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

  /**
   * Resetta tutti i valori dei nodi (da chiamare sul nodo padre)
   */
  void ClearAllValues(){
    List<Node> listanodi=_getNodiFiglio();
    for(Node nodo in listanodi){
      nodo.value=null;
    }
  }

  List<Node> _getNodiFiglio(){

    List<Node> listaNodi=[this];
    if(leafNodes != null){
      for(Node node in leafNodes) {
        listaNodi.addAll(node._getNodiFiglio());
      }
    }
    return listaNodi;
  }

  List<Node> getOrderedNodiFiglio(){
    List<Node> listaNodi=_getNodiFiglio();
    List<Node> orderedNodi=new List(listaNodi.length);

    for(int i=0; i<listaNodi.length;i++){
      int j=0;
      while(listaNodi[j].order!=i)
        j++;
      orderedNodi[i]=(listaNodi[j]);
    }

    return orderedNodi;
  }

  List<String> getStringOrderedNodiFiglio(){
    List<Node> listaNodi=getOrderedNodiFiglio();
    List<String>listaString=new List();
    for(Node node in listaNodi){
      listaString.add(node.name);
    }
    return listaString;
  }

  void ReorderNodes(List<int> listaOrdine){
    List<Node> listaNodi=getOrderedNodiFiglio();
    for(int i=0; i<listaNodi.length;i++)
      listaNodi[i].order=listaOrdine[i];
  }

  String MantissaCorrection(){
    String stringValue=value.toString();

    //stacco la parte esponenziale e la attacco alla fine
    String append="";
    if(stringValue.contains("e")) {
      append = "e" + stringValue.split("e")[1];
      stringValue=stringValue.split("e")[0];
    }

    if(stringValue.contains("999999")){
      if(stringValue.indexOf("999999")>(stringValue.indexOf(".") ==-1 ? stringValue.indexOf("999999")+1 : stringValue.indexOf("."))){ // se il numero cercato è dopo la virgola
        int index=stringValue.split(".")[1].indexOf("999999"); //es:    1.999999 index=1;
        value=value+pow(10,-index-6);                          //10^-6 =0.000001 che sommato a value dà 2 (6 perchè 999999 ha 6 cifre)
        stringValue=value.toString();
      }
    }

    bool virgola=false;
    //eliminazione problema mantissa
    for(int i=0;i<stringValue.length;i++){
      if(stringValue.substring(i,i+1)==".")
        virgola=true;
      if(virgola && stringValue.substring(i,stringValue.length).contains("000000")){
        stringValue=stringValue.split("000000")[0];
        break;
      }
      if(virgola && stringValue.substring(i,stringValue.length).contains("999999")){
        stringValue=stringValue.split("999999")[0];
        break;
      }
    }

    //riduzione a 9 cifre significative
    bool nonZero=false;
    int i;
    for(i=0;i<stringValue.length && !nonZero;i++){
      String char =stringValue.substring(i,i+1);
      if(char!="0" && char!=".")
        nonZero=true;
    }
    if(i+9<stringValue.length) {
      stringValue = stringValue.substring(0,i+9);
    }

    //correzione finali con .
    if(stringValue.endsWith("."))
      stringValue=stringValue+"0";
    return stringValue+append;

  }

}
