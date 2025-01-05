import 'package:converterpro/styles/consts.dart';
import 'package:translations/app_localizations.dart';
import 'package:flutter/material.dart';

typedef Item = ({int id, String title});

class ReorderPage extends StatefulWidget {
  final String title;
  final List<String> itemsList;
  final void Function(List<int>? orderList) onSave;

  const ReorderPage({
    required this.itemsList,
    required this.onSave,
    required this.title,
    super.key,
  });

  @override
  State<ReorderPage> createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  late List<Item> _itemsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _itemsList =
        widget.itemsList.indexed.map((e) => (id: e.$1, title: e.$2)).toList();

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('confirm'),
        tooltip: AppLocalizations.of(context)!.save,
        onPressed: () {
          List<int> orderList = [];
          bool hasSomethingchanged = false;
          for (int i = 0; i < _itemsList.length; i++) {
            int currentIndex = _itemsList[i].id;
            orderList.add(currentIndex);
            if (i != currentIndex) hasSomethingchanged = true;
          }
          // if some modification has been done returns them, otherwise it will
          // return null
          widget.onSave(hasSomethingchanged ? orderList : null);
        },
        child: const Icon(Icons.check),
      ),
      body: StatefulBuilder(
        builder: (context, setState) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar.large(title: Text(widget.title)),
            SliverPadding(
              // Space for FAB + navigation bar (android)
              padding: EdgeInsets.only(
                bottom: 60 + MediaQuery.of(context).padding.bottom,
              ),
              sliver: SliverReorderableList(
                onReorder: (int oldIndex, int newIndex) =>
                    setState(() => _updateItemsOrder(oldIndex, newIndex)),
                itemCount: widget.itemsList.length,
                itemBuilder: (context, index) => Stack(
                  key: Key('reaorderableListItem_$index'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 34),
                      child: ListTile(
                        key: ValueKey(_itemsList[index].id),
                        title: Text(
                          _itemsList[index].title,
                          style: const TextStyle(fontSize: singlePageTextSize),
                        ),
                      ),
                    ),
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      top: 0,
                      bottom: 0,
                      start: 16,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_handle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateItemsOrder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _itemsList.removeAt(oldIndex);
    _itemsList.insert(newIndex, item);
  }
}
