import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

class ConversionPage extends StatefulWidget {

  Node fatherNode;
  ConversionPage(this.fatherNode);

  @override
  _ConversionPage createState() => new _ConversionPage();
}

class _ConversionPage extends State<ConversionPage> {
  List<Node> listaNodi;
  List<TextEditingController> listaController = new List();
  List<FocusNode> listaFocus = new List();
  Node selectedNode;

  @override
  void didUpdateWidget(ConversionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
  }

@override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize(){
    listaNodi = widget.fatherNode.getOrderedNodiFiglio();
    listaController.clear();
    listaFocus.clear();
    for (Node node in listaNodi) {
      listaController.add(new TextEditingController());
      FocusNode focus = new FocusNode();
      focus.addListener(() {
        if (focus.hasFocus) {
          if (selectedNode != null) {
            selectedNode.selectedNode = false;
          }
          node.selectedNode = true;
          node.convertedNode = true;
          selectedNode = node;
        }
      });
      listaFocus.add(focus);
    }
  }

  @override
  void dispose() {
    FocusNode focus;
    TextEditingController TEC;
    for (int i = 0; i < listaFocus.length; i++) {
      focus = listaFocus[i];
      focus.removeListener(() {});
      focus.dispose();
      TEC = listaController[i];
      TEC.dispose();
    }
    super.dispose();
  }

  List<UnitCard> createList() {
    List<UnitCard> listaCard = new List();
    listaNodi = widget.fatherNode.getOrderedNodiFiglio();
    for (int i = 0; i < listaNodi.length; i++) {
      Node nodo = listaNodi[i];
      TextEditingController controller;
      controller = listaController[i];

      if (nodo.value != null && !nodo.selectedNode)
        controller.text = nodo.value.toString();
      else if (nodo.value == null && !nodo.selectedNode) controller.text = "";

      listaCard.add(new UnitCard(
          node: nodo,
          textField: TextField(
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
            controller: controller,
            focusNode: listaFocus[i],
            onChanged: (String txt) {
              nodo.value = txt == "" ? null : double.parse(txt);
              setState(() {
                widget.fatherNode.ResetConvertedNode();
                widget.fatherNode.Convert();
              });
            },
          )));
    }
    return listaCard;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: new EdgeInsets.only(top: 10.0,left: 10.0,right:10.0,bottom: 50.0),
        children: createList(),//listCard
    );
  }
}
