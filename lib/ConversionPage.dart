import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConversionPage extends StatefulWidget{
  @override
  _ConversionPage createState() => new _ConversionPage();
}

class _ConversionPage extends State<ConversionPage>{

  static TextEditingController T1=new TextEditingController();
  static TextEditingController T2=new TextEditingController();

  List<TextEditingController> listaController=[T1,T2];

  static Node foot=Node(isMultiplication: true, coefficient: 12.0, name: "foot", selectedNode: false, convertedNode: false);
  static Node inch=Node(isMultiplication: true, coefficient: 2.54, name: "inch", leafNodes: [foot], selectedNode: false, convertedNode: false);
  static Node millimetro=Node(isMultiplication: false, coefficient: 10.0, name: "millimetro", selectedNode: false, convertedNode: false);
  static Node centimetro=Node(isMultiplication: false, coefficient: 100.0, name: "centimetro", leafNodes: [millimetro,inch], selectedNode: true, convertedNode: true);
  static Node metro=Node(name: "metro", leafNodes: [centimetro], selectedNode: false, convertedNode: false);

  int a=0;

  List<Node> listaNodi=metro.getNodiFiglio();

  List<UnitCard> _createList(){
    List<UnitCard> listaCard=new List();
    for (Node nodo in listaNodi){
      TextEditingController controller=new TextEditingController();
      listaController.add(controller);
      controller.text = nodo.value!= null ? nodo.value.toString() : "";
      listaCard.add(new UnitCard(
          node: nodo,
          textField: TextField(
            style: TextStyle(fontSize: 16.0,color: Colors.black,),
            keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
            controller: controller,
            onChanged: (String txt){
              nodo.value = txt == "" ? null : double.parse(txt);
              updateNodes(nodo);
            },
          )
      ));
    }
    return listaCard;
  }

  bool first=false;

  @override
  Widget build(BuildContext context) {

    List<UnitCard> listCard;

    if(!first){
      listCard=_createList();
      first=false;
    }


    return Scaffold(
      appBar: AppBar(title: new Text("Lunghezza"),),
      body: ListView(
        padding: new EdgeInsets.all(10.0),
        children: listCard
      ),
      floatingActionButton: new FloatingActionButton(onPressed: (){
        print(metro.toString());
        print(centimetro.toString());
        print(millimetro.toString());
        print(inch.toString());
        print(foot.toString());
      }),
    );
  }

  void updateNodes(Node node){
    setState(() {
      a++;
      if(a==2)
        print("ciao");
      metro.ResetConvertedNode();
      metro.Convert();
      for(int i=0;i<listaNodi.length;i++) {
        if(identical(listaNodi[i],node))
          break;
        else
          listaController[i].text = listaNodi[i].value.toString();

      }
    });
  }

}

/*class MyTextField extends StatefulWidget{
  MyTextField(this.controller, this.node, this.nodeFather);
  List<TextEditingController> controller;
  Node node,nodeFather;
  @override
  _MyTextField createState() => new _MyTextField(controller,node,nodeFather);
}

class _MyTextField extends State<MyTextField>{

  _MyTextField(this.controller, this.node, this.nodeFather);

  List<TextEditingController> controller;
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
}*/