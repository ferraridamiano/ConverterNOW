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

    //risoluzione problema 0.99999999999 -> 1.0
    if(stringValue.contains("999999")){
      if(stringValue.indexOf("999999")>(stringValue.indexOf(".") ==-1 ? stringValue.indexOf("999999")+1 : stringValue.indexOf("."))){ // se il numero cercato è dopo la virgola
        int index=stringValue.split(".")[1].indexOf("999999"); //es:    1.999999 index=1;
        value=value+pow(10,-index-6);                          //10^-6 =0.000001 che sommato a value dà 2 (6 perchè 999999 ha 6 cifre)
        stringValue=value.toString();
      }
    }

    //eliminazione problema 1.00000000000000003 --> 1.0
    bool virgola=false;
    for(int i=0;i<stringValue.length;i++){
      if(stringValue.substring(i,i+1)==".")
        virgola=true;
      if(virgola && stringValue.substring(i,stringValue.length).contains("000000")){
        stringValue=stringValue.split("000000")[0];
        break;
      }
    }

    //riduzione a 9 cifre significative dopo la virgola
    bool nonZero=false;
    virgola=false;
    int i;
    for(i=0;i<stringValue.length && !nonZero;i++){    //cerco l'indice del primo carattere non nullo dopo la virgola
      String char =stringValue.substring(i,i+1);      //estraggo ogni carattere
      if(char==".")                                   //se è passata la virgola
        virgola=true;                                 //metto il flag che è già stata passata
      else if(virgola && char!="0")                   //se la virgola è passata e il primo carattere  è diverso da "0"
        nonZero=true;
    }
    if(i+9<stringValue.length) {
      stringValue = stringValue.substring(0,i+9);
    }

    //correzione finali con .
    if(stringValue.endsWith("."))
      stringValue=stringValue+"0";
    return stringValue+append; //aggiungo la parte esponenziale se c'è

  }

}

class Calculator extends StatefulWidget{

  Calculator(this.color);
  Color color;

  @override
  _Calculator createState() => new _Calculator();
}

class _Calculator extends State<Calculator>{
  static const space=1.0;
  String text="";
  bool alreadyDeleted=false;
  bool isResult=false;
  double firstNumber,secondNumber;
  int operation=0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //color: widget.color,
      width: 279.0,
      height: 349.0,
      decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:new BorderRadius.all(new Radius.circular(6.0)),
                  color: widget.color
                  ),
      child: Column(
        children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(width: 197.0,child: 
              Text(text,style: TextStyle(fontSize: 24.0,color: Colors.white.withAlpha(200)),maxLines: 1,),
            ),
            SizedBox(width: space,),
            _button(isResult ? "CE" : "←", (){
              if(isResult){
                operation=0;
                firstNumber=secondNumber=null;
                setState((){
                  text="";
                });
              }
              isResult=false;
              deleteLastChar();
              },false),
          ],
        ), 
        SizedBox(height: space,),
        Row(
          children: <Widget>[
          _button("7", (){addChar("7");},true),
          SizedBox(width: space,),
          _button("8", (){addChar("8");},true),
          SizedBox(width: space,),
          _button("9", (){addChar("9");},true),
          SizedBox(width: space,),
          _button("÷", (){setOperation(4);},false),
        ],),
        SizedBox(height: space,),
        Row(
          children: <Widget>[
          _button("4", (){addChar("4");},true),
          SizedBox(width: space,),
          _button("5", (){addChar("5");},true),
          SizedBox(width: space,),
          _button("6", (){addChar("6");},true),
          SizedBox(width: space,),
          _button("x", (){setOperation(3);},false),
        ],),
        SizedBox(height: space,),
        Row(
          children: <Widget>[
          _button("1", (){addChar("1");},true),
          SizedBox(width: space,),
          _button("2", (){addChar("2");},true),
          SizedBox(width: space,),
          _button("3", (){addChar("3");},true),
          SizedBox(width: space,),
          _button("-", (){setOperation(2);},false),
        ],),
        SizedBox(height: space,),
        Row(
          children: <Widget>[
          _button(".", (){addChar(".");},false),
          SizedBox(width: space,),
          _button("0", (){addChar("0");},true),
          SizedBox(width: space,),
          _button("=", (){computeCalculus();},false),
          SizedBox(width: space,),
          _button("+", (){setOperation(1);},false),
        ],),
      ],),

    );
  }

  void addChar(String char){
    if(!alreadyDeleted && firstNumber!=null && text.length>0){
      text="";
      alreadyDeleted=true;
    }
    if(char != "." || (char=="." && !text.contains(".") && text.length>0)){
      setState((){
        text+=char;
      });
    }
  }
  void deleteLastChar(){
    if(text.length>0){
      setState((){
        text=text.substring(0,text.length-1);
      });
    }
  }

  void setOperation(int op){
    operation=op;
    firstNumber=double.parse(text);
  }
  void computeCalculus(){
    secondNumber=double.parse(text);
    double result;
    if(firstNumber==null || secondNumber==null || operation==0 || (operation==4 && secondNumber==0))
      result=null;
    else{
      switch(operation){
        case 1:
        result=firstNumber+secondNumber;
        break;
        case 2:
        result=firstNumber-secondNumber;
        break;
        case 3:
        result=firstNumber*secondNumber;
        break;
        case 4:
        result=firstNumber/secondNumber;
        break;
        
      }
    }
    if(result!=null){
      String stringResult=result.toString();
      if(stringResult.endsWith(".0"))
        stringResult=stringResult.substring(0,stringResult.length-2);
      setState((){
        text=stringResult;
      });
    }
    alreadyDeleted=false;
    isResult=true;
  }


  Widget _button (String number, Function() f, bool isNum){ // Creating a method of return type Widget with number and function f as a parameter
    return ButtonTheme(
      minWidth: 69.0,
      height: 69.0,
      child:RaisedButton(
        child: Text(number,
          style:  TextStyle(fontSize: 24.0)),
          textColor: Colors.white.withAlpha(200),
          color: Color(isNum ? 0x30000000 : 0x50000000),
          elevation: 0.0,
          onPressed: f,
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
      )
      //height: 69.0,
      //minWidth: 69.0,
      
    );
  }

}