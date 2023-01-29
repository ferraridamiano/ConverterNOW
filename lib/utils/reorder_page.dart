import 'dart:io';
import 'package:converterpro/styles/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:translations/app_localizations.dart';
import 'package:flutter/material.dart';

class ReorderPage extends StatefulWidget {
  final String title;
  final List<String> itemsList;
  final void Function(List<int>? orderList) onSave;

  const ReorderPage({
    required this.itemsList,
    required this.onSave,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<ReorderPage> createState() => _ReorderPageState();
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
    final bool isMobileDevice =
        !kIsWeb && (Platform.isIOS || Platform.isAndroid);

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
              padding: const EdgeInsets.only(bottom: 60),
              sliver: SliverReorderableList(
                  onReorder: (int oldIndex, int newIndex) =>
                      setState(() => _updateItemsOrder(oldIndex, newIndex)),
                  itemCount: widget.itemsList.length,
                  itemBuilder: (context, index) {
                    Widget item = ListTile(
                      key: ValueKey(_itemsList[index].id),
                      title: Center(
                        child: Text(
                          _itemsList[index].title,
                          style: const TextStyle(fontSize: singlePageTextSize),
                        ),
                      ),
                      onTap: isMobileDevice
                          ? () {
                              final snackBar = SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .longPressAdvice),
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          : null,
                    );
                    final Key itemGlobalKey =
                        Key('reaorderableListItem_$index');

                    switch (Theme.of(context).platform) {
                      case TargetPlatform.linux:
                      case TargetPlatform.windows:
                      case TargetPlatform.macOS:
                        return Stack(
                          key: itemGlobalKey,
                          children: <Widget>[
                            item,
                            Positioned.directional(
                              textDirection: Directionality.of(context),
                              top: 0,
                              bottom: 0,
                              end: 8,
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: ReorderableDragStartListener(
                                  index: index,
                                  child: const Icon(Icons.drag_handle),
                                ),
                              ),
                            ),
                          ],
                        );
                      case TargetPlatform.iOS:
                      case TargetPlatform.android:
                      case TargetPlatform.fuchsia:
                        return ReorderableDelayedDragStartListener(
                          key: itemGlobalKey,
                          index: index,
                          child: item,
                        );
                    }
                  }),
            ),
          ],
        ),
      ),
      /*body: Column(
        children: [
          widget.header != null ? widget.header! : const SizedBox(),
          Expanded(
            child: StatefulBuilder(
              builder: (context, setState) => Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ReorderableListView(
                  scrollController: ScrollController(),
                  padding: const EdgeInsets.only(bottom: 60),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() => _updateItemsOrder(oldIndex, newIndex));
                  },
                  children: List.generate(
                    widget.itemsList.length,
                    (index) {
                      return ListTile(
                        key: ValueKey(_itemsList[index].id),
                        title: Center(
                          child: Text(
                            _itemsList[index].title,
                            style:
                                const TextStyle(fontSize: singlePageTextSize),
                          ),
                        ),
                        onTap: isMobileDevice
                            ? () {
                                final snackBar = SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .longPressAdvice),
                                  behavior: SnackBarBehavior.floating,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),*/
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
