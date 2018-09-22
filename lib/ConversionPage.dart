import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';


class ConversionPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    Node foot=Node(isMultiplication: true, coefficient: 12.0, name: "foot", selectedNode: false, convertedNode: false);
    Node inch=Node(isMultiplication: true, coefficient: 2.54, name: "inch", leafNodes: [foot], selectedNode: false, convertedNode: false);
    Node millimetro=Node(isMultiplication: false, coefficient: 10.0, name: "millimetro", selectedNode: false, convertedNode: false);
    Node centimetro=Node(isMultiplication: false, coefficient: 100.0, name: "centimetro", leafNodes: [millimetro,inch], selectedNode: false, convertedNode: false);
    Node metro=Node(name: "metro", leafNodes: [centimetro], selectedNode: false, convertedNode: false);
    //metro.Convert();
    List<Node> listaNodi=metro.getNodiFiglio();
    List<UnitCard> listaCard=new List();
    for (Node nodo in listaNodi){
      TextEditingController controller=new TextEditingController();
      controller.text=nodo.value.toString();
      listaCard.add(new UnitCard(
        node: nodo,
        textField: MyTextField(controller,nodo,metro)
      ));
    }

    return Scaffold(
      appBar: AppBar(title: new Text("Lunghezza"),),
      body: ListView(
        padding: new EdgeInsets.all(10.0),
        children: listaCard
      ),
      floatingActionButton: new FloatingActionButton(onPressed: (){
        print("DEBUG");
      }),
    );
  }
}

class MyTextField extends StatefulWidget{
  MyTextField(this.controller, this.node, this.nodeFather);
  TextEditingController controller;
  Node node,nodeFather;
  @override
  _MyTextField createState() => new _MyTextField(controller,node,nodeFather);
}

class _MyTextField extends State<MyTextField>{

  _MyTextField(this.controller, this.node, this.nodeFather);

  TextEditingController controller;
  Node node,nodeFather;

  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }
  void _onFocusChange(){
    if(!_focus.hasFocus){                                                       //se ha perso il focus
      node.selectedNode=false;
      node.convertedNode=false;
    }
    else{                                                                       //se ottengo il focus
      node.selectedNode=true;
      node.convertedNode=true;
      nodeFather.ResetConvertedNode();
    }

  }

  @override
  Widget build(BuildContext context) {
    return new TextField(
      style: TextStyle(fontSize: 16.0,color: Colors.black,),
      keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
      focusNode: _focus,
      onChanged: (String text){
        node.value=double.parse(text);
        nodeFather.Convert();
      },
    );
  }
}