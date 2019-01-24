import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

class ConversionPage extends StatefulWidget {

  Node fatherNode;
  String title;
  String subtitle;
  ConversionPage(this.fatherNode, this.title, this.subtitle);

  @override
  _ConversionPage createState() => new _ConversionPage();
}

class _ConversionPage extends State<ConversionPage> {
  List<TextEditingController> listaController = new List();
  List<FocusNode> listaFocus = new List();
  Node selectedNode;
  List listaNodi;

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
    listaController.clear();
    listaFocus.clear();
    listaNodi=widget.fatherNode.getOrderedNodiFiglio();
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

  List<ListItem> createList() {
    List<ListItem> listaCard = new List();
    listaCard.add(bigHeader(title:widget.title, subTitle: widget.subtitle));
    for (int i = 0; i < listaNodi.length; i++) {
      Node nodo = listaNodi[i];
      TextEditingController controller;
      controller = listaController[i];

      if (nodo.value != null && !nodo.selectedNode)
        controller.text = nodo.MantissaCorrection();
      else if (nodo.value == null && !nodo.selectedNode) controller.text = "";

      listaCard.add(myCard(
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
    List itemList=createList();
    return ListView.builder(
          padding: new EdgeInsets.only(top: 10.0,left: 10.0,right:10.0,bottom: 25.0),
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            final item = itemList[index];

            if (item is bigHeader) {
              return bigTitle(item.title, item.subTitle);
            } else if (item is myCard) {
              return UnitCard(node: item.node,textField: item.textField,);
            }
          });
  }
}
