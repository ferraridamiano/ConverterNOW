import 'package:flutter/material.dart';
import 'reorderable_list.dart';

class ReorderPage extends StatefulWidget {
  ReorderPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ReorderPage createState() => new _ReorderPage();
}

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

class _ReorderPage extends State<ReorderPage> {
  List<ItemData> _items;

  _ReorderPage() {
    _items = new List();
    for (int i = 0; i < 100; ++i)
      _items.add(new ItemData("List Item " + i.toString(), new ValueKey(i)));
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    for (int i = 0; i < _items.length; ++i) {
      if (_items[i].key == key) return i;
    }
    return -1;
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint(
          "Reordering " + item.toString() + " -> " + newPosition.toString());
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: ReorderableList(
                  onReorder: this._reorderCallback,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (BuildContext c, index) => new Item(
                        data: _items[index],
                        // first and last attributes affect border drawn during dragging
                        first: index == 0,
                        last: index == _items.length - 1),
                  )))
        ]));
  }
}

class Item extends StatelessWidget {
  Item({this.data, this.first, this.last});

  final ItemData data;
  final bool first;
  final bool last;

  // Builds decoration for list item; During dragging we don't want top border on first item
  // and bottom border on last item
  BoxDecoration _buildDecoration(BuildContext context, bool dragging) {
    return BoxDecoration(
        border: Border(
            top: first && !dragging
                ? Divider.createBorderSide(context) //
                : BorderSide.none,
            bottom: last && dragging
                ? BorderSide.none //
                : Divider.createBorderSide(context)));
  }

  Widget _buildChild(BuildContext context, bool dragging) {
    return Container(
      // slightly transparent background white dragging (just like on iOS)
        decoration:
        BoxDecoration(color: dragging ? Color(0xD0FFFFFF) : Colors.white),
        child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(data.title,
                        style: Theme.of(context).textTheme.subhead)),
                Icon(Icons.reorder,
                    color: dragging ? Color(0xFF555555) : Color(0xFF888888)),
              ],
            )),
        padding: new EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild,
        decorationBuilder: _buildDecoration);
  }
}