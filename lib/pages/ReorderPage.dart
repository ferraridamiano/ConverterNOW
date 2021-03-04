import 'package:converterpro/styles/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

class ReorderPage extends StatefulWidget {
  final List<String> itemsList;

  const ReorderPage(this.itemsList);

  @override
  _ReorderPageState createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  List<Item> _itemsList = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.itemsList.length; i++) _itemsList.add(Item(i, widget.itemsList[i]));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: AppLocalizations.of(context)!.save,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          onPressed: () {
            List<int> orderList = [];
            bool hasSomethingchanged = false;
            for (int i = 0; i < _itemsList.length; i++) {
              int currentIndex = _itemsList[i].id;
              orderList.add(currentIndex);
              if (i != currentIndex) hasSomethingchanged = true;
            }
            //if some modification has been done returns them, otherwise it will return null
            Navigator.pop(context, hasSomethingchanged ? orderList : null);
          },
          elevation: 10.0,
          backgroundColor: Theme.of(context).accentColor,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                tooltip: AppLocalizations.of(context)!.back,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, null); // no modifications will be done
                },
              ),
            ],
          ),
        ),
        body: ReorderableListView(
          padding: EdgeInsets.symmetric(
            horizontal: Math.max(0, (MediaQuery.of(context).size.width - SINGLE_PAGE_FIXED_HEIGHT) / 2),
          ),
          onReorder: (int oldIndex, int newIndex) {
            setState(() => _updateItemsOrder(oldIndex, newIndex));
          },
          children: List.generate(
            _itemsList.length,
            (index) {
              return SizedBox(
                width: SINGLE_PAGE_FIXED_HEIGHT,
                height: 48,
                child: ListTile(
                  title: Center(
                    child: Text(
                      _itemsList[index].title,
                      style: TextStyle(fontSize: SINGLE_PAGE_TEXT_SIZE),
                    ),
                  ),
                  onTap: () {
                    final snackBar = SnackBar(
                      content: Text(AppLocalizations.of(context)!.longPressAdvice),
                      behavior: SnackBarBehavior.floating,
                    );
                    _scaffoldKey.currentState!.showSnackBar(snackBar);
                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
                key: ValueKey(_itemsList[index].id),
              );
            },
          ),
        ),
      ),
    );
  }

  void _updateItemsOrder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Item item = _itemsList.removeAt(oldIndex);
    _itemsList.insert(newIndex, item);
  }
}

class Item {
  final int id;
  final String title;
  Item(this.id, this.title);
}
