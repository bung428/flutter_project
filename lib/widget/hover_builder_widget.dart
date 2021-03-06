import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef HoverWidgetBuilder = Widget Function(BuildContext context, bool hover);

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    Key? key,
    required this.builder,
    this.cursor = MouseCursor.defer,
  }) : super(key: key);

  final HoverWidgetBuilder builder;
  final MouseCursor cursor;

  @override
  _HoverBuilderState createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) => setState(() => hover = true),
      onExit: (PointerExitEvent event) => setState(() => hover = false),
      cursor: widget.cursor,
      child: widget.builder(context, hover),
    );
  }
}