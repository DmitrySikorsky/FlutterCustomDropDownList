// Copyright © 2022 Dmitry Sikorsky. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_drop_down_list/defaults.dart';
import 'package:flutter_custom_drop_down_list/list_item.dart';

class DropDownList<T> extends StatefulWidget {
  final List<ListItem<T>> listItems;
  final T? value;
  final ValueChanged<T?>? onChange;

  const DropDownList({
    Key? key,
    required this.listItems,
    this.value,
    this.onChange,
  }) : super(key: key);

  @override
  _DropDownListState<T> createState() => _DropDownListState<T>();
}

class _DropDownListState<T> extends State<DropDownList<T>> {
  final GlobalKey _key = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  ListItem? _selected;
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isOverlayShown = false;
  OverlayEntry? _overlay;
  FocusScopeNode? _focusScopeNode;

  @override
  void initState() {
    super.initState();
    if (widget.listItems.isNotEmpty) {
      _selected = widget.value == null ? widget.listItems.first : widget.listItems.firstWhereOrNull((listItem) => listItem.value == widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _onTap,
        child: FocusableActionDetector(
          focusNode: _focusNode,
          mouseCursor: SystemMouseCursors.click,
          actions: {
            ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => _onTap()),
          },
          onShowFocusHighlight: (isFocused) => setState(() => _isFocused = isFocused),
          onShowHoverHighlight: (isHovered) => setState(() => _isHovered = isHovered),
          child: Container(
            key: _key,
            padding: const EdgeInsets.all(Defaults.spacing),
            decoration: BoxDecoration(
              color: Defaults.background,
              border: Border.all(
                color: _isHovered || _isFocused || _isOverlayShown ? Defaults.active : Defaults.normal,
                width: Defaults.edge,
              ),
              borderRadius: BorderRadius.circular(Defaults.radius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selected == null ? '' : _selected!.title),
                const SizedBox(width: Defaults.spacing / 2.0),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _focusScopeNode?.dispose();
  }

  OverlayEntry _createOverlay() {
    _focusScopeNode = FocusScopeNode();
    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              child: Material(
                color: Colors.transparent,
                child: FocusScope(
                  node: _focusScopeNode,
                  child: _createListItems(),
                  onKey: (node, event) {
                    if (event.logicalKey == LogicalKeyboardKey.escape) {
                      _removeOverlay();
                    }

                    return KeyEventResult.ignored;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeOverlay() {
    _overlay!.remove();
    _isOverlayShown = false;
    _focusScopeNode!.dispose();
    FocusScope.of(context).nextFocus();
  }

  Widget _createListItems() {
    RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Defaults.spacing / 2.0),
      decoration: BoxDecoration(
        color: Defaults.background,
        border: Border.all(
          color: Defaults.active,
          width: Defaults.edge,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(Defaults.radius),
        ),
      ),
      width: renderBox.size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.listItems
            .map((listItem) => ListItem(
                  listItem.title,
                  onTap: () => _onListItemTap(listItem),
                ))
            .toList(),
      ),
    );
  }

  void _onTap() {
    if (_isOverlayShown) {
      _removeOverlay();
    } else {
      _overlay = _createOverlay();
      Overlay.of(context)?.insert(_overlay!);
      _isOverlayShown = true;
      FocusScope.of(context).setFirstFocus(_focusScopeNode!);
    }
  }

  void _onListItemTap(ListItem listItem) {
    _removeOverlay();
    setState(() {
      _selected = listItem;
    });

    widget.onChange?.call(listItem.value);
  }
}
