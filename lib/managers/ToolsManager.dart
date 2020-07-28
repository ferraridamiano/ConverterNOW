import 'package:converterpro/utils/Localization.dart';
import 'package:flutter/material.dart';

class ToolsManager extends StatefulWidget{
  final Function openDrawer;

  ToolsManager(this.openDrawer);

  @override
    _ToolsManager createState() => _ToolsManager();
}

class _ToolsManager extends State<ToolsManager> {

  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem> listaMenu = new List();
    listaMenu.add(DropdownMenuItem(child: Text("1.")));
    listaMenu.add(DropdownMenuItem(child: Text("2.")));
    listaMenu.add(DropdownMenuItem(child: Text("3.")));
    listaMenu.add(DropdownMenuItem(child: Text("4.")));
    listaMenu.add(DropdownMenuItem(child: Text("5.")));
    listaMenu.add(DropdownMenuItem(child: Text("6.")));
    
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: Image.asset("resources/images/calculator.png", width: 30.0,)),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Builder(builder: (context) {
              return IconButton(
                tooltip: MyLocalizations.of(context).trans('menu'),
                icon: Icon(Icons.menu,color: Colors.white,),
                onPressed: () {
                widget.openDrawer();
              });
            }),
            Row(children: <Widget>[
              IconButton(
                tooltip: MyLocalizations.of(context).trans('elimina_tutto'),
                icon: Icon(Icons.clear,color: Colors.white),
                onPressed: () {
                  //todo
                },),
              IconButton(
                tooltip: MyLocalizations.of(context).trans('cerca'),
                icon: Icon(Icons.search,color: Colors.white,),
                /*onPressed: () async {
                  final int paginaReindirizzamento=await showSearch(context: context,delegate: _searchDelegate);
                  if(paginaReindirizzamento!=null)
                    _onSelectItem(paginaReindirizzamento);
                },*/
              ),
            ],)
          ],
        ),
      ),
      body: Center(
        child: Text("Tools", style: TextStyle(fontSize: 40.0),),
      ),
    );
  }

}