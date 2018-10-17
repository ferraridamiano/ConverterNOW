import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'dart:collection';
import 'dart:math';

typedef bool RedorderItemCallback(Key draggedItem, Key newPosition);

class ReorderableList extends StatefulWidget {
  ReorderableList({this.child, this.onReorder, this.scrollController});

  final Widget child;

  final RedorderItemCallback onReorder;

  // Optional scroll controller used when scrolling during dragging; If not set
  // PrimaryScrollController is used
  final ScrollController scrollController;

  @override
  State<StatefulWidget> createState() => new _ReorderableListState();
}

class _ReorderableListState extends State<ReorderableList>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.passthrough,
      children: <Widget>[widget.child, new _DragProxy()],
    );
  }

  get dragging => _dragging;

  Key _dragging;
  _Recognizer _recognizer;
  _DragProxyState _dragProxy;

  void startDragging(Key key, PointerEvent event) {
    _finalAnimation?.stop(canceled: true);
    _finalAnimation?.dispose();
    _finalAnimation = null;

    if (_dragging != null) {
      var current = _items[_dragging];
      _dragging = null;
      current?.update();
    }

    _dragging = key;
    _lastReportedKey = null;
    if (_recognizer == null) {
      _recognizer = new _Recognizer()
        ..onDown = _dragDown
        ..onUpdate = _dragUpdate
        ..onEnd = _dragEnd
        ..onCancel = _dragCancel;
    }
    _recognizer.addPointer(event);
  }

  ScrollController get _scrollController =>
      widget.scrollController ?? PrimaryScrollController.of(context);

  void _dragDown(DragDownDetails details) {
    HapticFeedback.selectionClick();
    final draggedItem = _items[_dragging];
    draggedItem.update();
    _dragProxy.setWidget(
        draggedItem.widget.childBuilder(draggedItem.context, true),
        draggedItem.context.findRenderObject());
    this._scrollController.addListener(this._scrolled);
  }

  void _scrolled() {
    checkDragPosition();
  }

  void _dragUpdate(DragUpdateDetails details) {
    _dragProxy.offset += details.delta.dy;
    checkDragPosition();
    maybeScroll();
  }

  void maybeScroll() async {
    if (!_scrolling && _scrollController != null && _dragging != null) {
      final position = this._scrollController.position;
      double newOffset;
      int duration = 14; // in ms
      double step = 1.0;
      double overdragMax = 20.0;
      double overdragCoef = 10.0;

      MediaQueryData d = MediaQuery.of(context, nullOk: true);

      double top = d?.padding?.top ?? 0.0;
      double bottom = context.size.height - (d?.padding?.bottom ?? 0.0);

      if (_dragProxy.offset < top &&
          position.pixels > position.minScrollExtent) {
        final overdrag = max(top - _dragProxy.offset, overdragMax);
        newOffset = max(position.minScrollExtent,
            position.pixels - step * overdrag / overdragCoef);
      } else if (_dragProxy.offset + _dragProxy.height > bottom &&
          position.pixels < position.maxScrollExtent) {
        final overdrag = max<double>(
            _dragProxy.offset + _dragProxy.height - bottom, overdragMax);
        newOffset = min(position.maxScrollExtent,
            position.pixels + step * overdrag / overdragCoef);
      }

      if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
        _scrolling = true;
        await this._scrollController.animateTo(newOffset,
            duration: Duration(milliseconds: duration), curve: Curves.linear);
        _scrolling = false;
        if (_dragging != null) {
          checkDragPosition();
          maybeScroll();
        }
      }
    }
  }

  bool _scrolling = false;

  void _dragCancel() {
    _dragEnd(null);
  }

  _dragEnd(DragEndDetails details) async {
    HapticFeedback.selectionClick();
    if (_scrolling) {
      var prevDragging = _dragging;
      _dragging = null;
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _dragging = prevDragging;
        _dragEnd(details);
      });
      return;
    }

    if (_scheduledRebuild) {
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _dragEnd(details);
      });
      return;
    }

    this._scrollController.removeListener(this._scrolled);

    var current = _items[_dragging];
    if (current == null) return;

    final originalOffset = _itemOffset(current);
    final dragProxyOffset = _dragProxy.offset;

    _finalAnimation = new AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        value: 0.0,
        duration: Duration(milliseconds: 300));

    _finalAnimation.addListener(() {
      _dragProxy.offset =
          Tween<double>(begin: dragProxyOffset, end: originalOffset)
              .lerp(_finalAnimation.value);
      _dragProxy.shadowOpacity = 1.0 - _finalAnimation.value;
    });

    await _finalAnimation.animateTo(1.0, curve: Curves.easeOut);

    if (_finalAnimation != null) {
      _finalAnimation.dispose();
      _finalAnimation = null;

      _dragging = null;
      _dragProxy.hide();
      current.update();
    }
  }

  void checkDragPosition() {
    if (_scheduledRebuild) {
      return;
    }
    final draggingState = _items[_dragging];
    if (draggingState == null) {
      return;
    }

    final draggingTop = _itemOffset(draggingState);
    final draggingHeight = draggingState.context.size.height;

    _ReorderableItemState closest;
    double closestDistance = 0.0;

    // These callbacks will be invoked on successful reorder, they will ensure that
    // reordered items appear on their old position and animate to new one
    List<Function> onReorderApproved = new List();

    if (_dragProxy.offset < draggingTop) {
      for (_ReorderableItemState item in _items.values) {
        if (item.key == _dragging) continue;
        final itemTop = _itemOffset(item);
        if (itemTop > draggingTop) continue;
        final itemBottom = itemTop +
            (item.context.findRenderObject() as RenderBox).size.height / 2;

        if (_dragProxy.offset < itemBottom) {
          onReorderApproved.add(() {
            _adjustItemTranslation(item.key, -draggingHeight, draggingHeight);
          });
          if (closest == null ||
              closestDistance > (itemBottom - _dragProxy.offset)) {
            closest = item;
            closestDistance = (itemBottom - _dragProxy.offset);
          }
        }
      }
    } else {
      double draggingBottom = _dragProxy.offset + draggingHeight;

      for (_ReorderableItemState item in _items.values) {
        if (item.key == _dragging) continue;
        final itemTop = _itemOffset(item);
        if (itemTop < draggingTop) continue;

        final itemBottom = itemTop +
            (item.context.findRenderObject() as RenderBox).size.height / 2;
        if (draggingBottom > itemBottom) {
          onReorderApproved.add(() {
            _adjustItemTranslation(item.key, draggingHeight, draggingHeight);
          });
          if (closest == null ||
              closestDistance > (draggingBottom - itemBottom)) {
            closest = item;
            closestDistance = draggingBottom - itemBottom;
          }
        }
      }
    }

    // _lastReportedKey check is to ensure we don't keep spamming the callback when reorder
    // was rejected for this key;
    if (closest != null &&
        closest.key != _dragging &&
        closest.key != _lastReportedKey) {
      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _scheduledRebuild = false;
      });
      _scheduledRebuild = true;
      _lastReportedKey = closest.key;
      if (widget.onReorder != null) {
        if (widget.onReorder(_dragging, closest.key)) {
          HapticFeedback.selectionClick();
          for (final f in onReorderApproved) {
            f();
          }
          _lastReportedKey = null;
        }
      }
    }
  }

  bool _scheduledRebuild = false;
  Key _lastReportedKey;
  //

  final _items = new HashMap<Key, _ReorderableItemState>();

  void registerItem(_ReorderableItemState item) {
    _items[item.key] = item;
  }

  void unregisterItem(_ReorderableItemState item) {
    if (_items[item.key] == item) _items.remove(item.key);
  }

  double _itemOffset(_ReorderableItemState item) {
    final topRenderBox = context.findRenderObject() as RenderBox;
    return (item.context.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero, ancestor: topRenderBox)
        .dy;
  }

  static _ReorderableListState of(BuildContext context) {
    return context
        .ancestorStateOfType(new TypeMatcher<_ReorderableListState>());
  }

  //

  Map<Key, AnimationController> _itemTranslations = new HashMap();

  double itemTranslation(Key key) {
    if (!_itemTranslations.containsKey(key))
      return 0.0;
    else
      return _itemTranslations[key].value;
  }

  void _adjustItemTranslation(Key key, double delta, double max) {
    double current = 0.0;
    final currentController = _itemTranslations[key];
    if (currentController != null) {
      current = currentController.value;
      currentController.stop(canceled: true);
      currentController.dispose();
    }

    current += delta;

    final newController = new AnimationController(
        vsync: this,
        lowerBound: current < 0.0 ? -max : 0.0,
        upperBound: current < 0.0 ? 0.0 : max,
        value: current,
        duration: const Duration(milliseconds: 300));
    newController.addListener(() {
      _items[key]?.setState(() {}); // update offset
    });
    newController.addStatusListener((AnimationStatus s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        newController.dispose();
        if (_itemTranslations[key] == newController) {
          _itemTranslations.remove(key);
        }
      }
    });
    _itemTranslations[key] = newController;

    newController.animateTo(0.0, curve: Curves.easeInOut);
  }

  AnimationController _finalAnimation;

  @override
  void dispose() {
    _finalAnimation?.dispose();
    for (final c in _itemTranslations.values) {
      c.dispose();
    }
    _scrolling = null;
    _recognizer?.dispose();
    super.dispose();
  }
}

typedef BoxDecoration ReorderableItemDecorationBuilder(
    BuildContext context, bool dragging);

typedef Widget ReorderableItemChildBuilder(BuildContext context, bool dragging);

class ReorderableItem extends StatefulWidget {
  ReorderableItem(
      {@required Key key, @required this.childBuilder, this.decorationBuilder})
      : super(key: key);

  final ReorderableItemDecorationBuilder decorationBuilder;
  final ReorderableItemChildBuilder childBuilder;

  @override
  createState() => new _ReorderableItemState();
}

class _ReorderableItemState extends State<ReorderableItem> {
  get key => widget.key;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    _listState = _ReorderableListState.of(context);

    _listState.registerItem(this);
    bool dragging = _listState.dragging == key;
    return Listener(
        onPointerDown: _routePointer,
        child: Transform(
            transform: new Matrix4.translationValues(
                0.0, _listState.itemTranslation(key), 0.0),
            child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: widget.decorationBuilder != null
                    ? widget.decorationBuilder(context, dragging)
                    : BoxDecoration(),
                child: Opacity(
                    opacity: dragging ? 0.0 : 1.0,
                    child: widget.childBuilder(context, dragging)))));
  }

  void _routePointer(PointerEvent event) {
    // TODO - this needs to be factored out and made more flexible
    RenderBox ro = this.context.findRenderObject();
    final query = MediaQuery.of(context);
    Offset point = ro.globalToLocal(event.position);
    if (point.dx > ro.size.width - 60 - (query?.padding?.right ?? 0.0)) {
      _listState.startDragging(key, event);
    }
  }

  void update() {
    setState(() {});
  }

  @override
  void deactivate() {
    _listState?.unregisterItem(this);
    _listState = null;
    super.deactivate();
  }

  _ReorderableListState _listState;
}

//
//
//

class _DragProxy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DragProxyState();
}

class _DragProxyState extends State<_DragProxy> {
  Widget _widget;
  Size _size;
  double _offset;

  _DragProxyState();

  void setWidget(Widget widget, RenderBox position) {
    setState(() {
      _shadowOpacity = 1.0;
      _widget = widget;
      final state = _ReorderableListState.of(context);
      RenderBox renderBox = state.context.findRenderObject();
      _offset = position.localToGlobal(Offset.zero, ancestor: renderBox).dy;
      _size = position.size;
    });
  }

  set offset(double newOffset) {
    setState(() {
      _offset = newOffset;
    });
  }

  get offset => _offset;

  get height => _size.height;

  double _shadowOpacity;

  set shadowOpacity(double val) {
    setState(() {
      _shadowOpacity = val;
    });
  }

  void hide() {
    setState(() {
      _widget = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _ReorderableListState.of(context);
    state._dragProxy = this;

    final double decorationHeight = 10.0;

    return _widget != null && _size != null && _offset != null
        ? new Positioned.fromRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Opacity(
                opacity: _shadowOpacity,
                child: Container(
                  height: decorationHeight,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0x50000000), width: 0.5)),
                      gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: <Color>[
                            Color(0x00000000),
                            Color(0x10000000),
                            Color(0x30000000)
                          ])),
                )),
            _widget,
            Opacity(
                opacity: _shadowOpacity,
                child: Container(
                  height: decorationHeight,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Color(0x50000000), width: 0.5)),
                      gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: <Color>[
                            Color(0x30000000),
                            Color(0x10000000),
                            Color(0x00000000)
                          ])),
                )),
          ],
        ),
        rect: new Rect.fromLTWH(0.0, _offset - decorationHeight,
            _size.width, _size.height + decorationHeight * 2 + 1.0))
        : new Container(width: 0.0, height: 0.0);
  }

  @override
  void deactivate() {
    _ReorderableListState.of(context)?._dragProxy = null;
    super.deactivate();
  }
}

//
// VerticalDragGestureRecognizer waits for kTouchSlop to be reached; We don't want that
// when reordering items
//

class _Recognizer extends VerticalDragGestureRecognizer {
  @override
  void handleEvent(PointerEvent event) {
    super.handleEvent(event);
    if (event is PointerMoveEvent && !_resolved) {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void addPointer(PointerEvent event) {
    super.addPointer(event);
    _resolved = false;
  }

  @override
  void resolve(GestureDisposition disposition) {
    if (disposition == GestureDisposition.accepted) _resolved = true;
    super.resolve(disposition);
  }

  bool _resolved = false;
}