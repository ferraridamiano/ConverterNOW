import 'dart:io';
import 'package:converterpro/styles/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReorderPage extends StatefulWidget {
  final Widget? header;
  final List<String> itemsList;
  final void Function(List<int>? orderList) onSave;

  const ReorderPage({
    required this.itemsList,
    required this.onSave,
    this.header,
    Key? key,
  }) : super(key: key);

  @override
  _ReorderPageState createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  late List<Item> _itemsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _itemsList = [];
    for (int i = 0; i < widget.itemsList.length; i++) {
      _itemsList.add(Item(i, widget.itemsList[i]));
    }

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.save,
        child: const Icon(
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          widget.header != null ? widget.header! : const SizedBox(),
          Expanded(
            child: ReorderList(
              _itemsList,
              bottomPadding: 60,
            ),
          ),
        ],
      ),
    );
  }
}

class ReorderList extends StatefulWidget {
  const ReorderList(this.itemsList, {this.bottomPadding = 0, Key? key}) : super(key: key);

  final List<Item> itemsList;
  final double bottomPadding;

  @override
  _ReorderListState createState() => _ReorderListState();
}

class _ReorderListState extends State<ReorderList> {
  @override
  Widget build(BuildContext context) {
    final bool isMobileDevice = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: ReorderableListView(
        scrollController: ScrollController(),
        padding: EdgeInsets.only(bottom: widget.bottomPadding),
        onReorder: (int oldIndex, int newIndex) {
          setState(() => _updateItemsOrder(oldIndex, newIndex));
        },
        children: List.generate(
          widget.itemsList.length,
          (index) {
            return ListTile(
              key: ValueKey(widget.itemsList[index].id),
              title: Center(
                child: Text(
                  widget.itemsList[index].title,
                  style: const TextStyle(fontSize: singlePageTextSize),
                ),
              ),
              onTap: isMobileDevice
                  ? () {
                      final snackBar = SnackBar(
                        content: Text(AppLocalizations.of(context)!.longPressAdvice),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  : null,
            );
          },
        ),
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
