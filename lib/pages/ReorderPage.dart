import 'package:converterpro/styles/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReorderPage extends StatefulWidget {
  final List<String> itemsList;
  final void Function(List<int>? orderList) onSave;

  const ReorderPage({required this.itemsList, required this.onSave});

  @override
  _ReorderPageState createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  late List<Item> _itemsList;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _itemsList = [];
    for (int i = 0; i < widget.itemsList.length; i++) {
      _itemsList.add(Item(i, widget.itemsList[i]));
    }

    return Expanded(
      child: Scaffold(
          key: _scaffoldKey,
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
              widget.onSave(hasSomethingchanged ? orderList : null);
            },
            elevation: 10.0,
            backgroundColor: Theme.of(context).accentColor,
          ),
          body: ReorderList(_itemsList)),
    );
  }
}

class ReorderList extends StatefulWidget {
  const ReorderList(this.itemsList, {Key? key}) : super(key: key);

  final List<Item> itemsList;

  @override
  _ReorderListState createState() => _ReorderListState();
}

class _ReorderListState extends State<ReorderList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() => _updateItemsOrder(oldIndex, newIndex));
      },
      children: List.generate(
        widget.itemsList.length,
        (index) {
          return SizedBox(
            width: SINGLE_PAGE_FIXED_HEIGHT,
            height: 48,
            child: ListTile(
              title: Center(
                child: Text(
                  widget.itemsList[index].title,
                  style: TextStyle(fontSize: SINGLE_PAGE_TEXT_SIZE),
                ),
              ),
              onTap: () {
                final snackBar = SnackBar(
                  content: Text(AppLocalizations.of(context)!.longPressAdvice),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            key: ValueKey(widget.itemsList[index].id),
          );
        },
      ),
    );
  }

  void _updateItemsOrder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Item item = widget.itemsList.removeAt(oldIndex);
    widget.itemsList.insert(newIndex, item);
  }
}

class Item {
  final int id;
  final String title;
  Item(this.id, this.title);
}
