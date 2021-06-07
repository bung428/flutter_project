import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_app_getx/widget/hover_builder_widget.dart';

class Spinner extends StatefulWidget {
  final int length;
  final SpinnerController? controller;
  final SpinnerItemBuilder itemBuilder;
  final bool isEnabled;

  const Spinner(
      {Key? key,
      required this.length,
      required this.itemBuilder,
      this.controller,
      this.isEnabled = true})
      : super(key: key);

  @override
  _SpinnerState createState() => _SpinnerState();
}

class SpinnerController extends ChangeNotifier {
  SpinnerController();

  SpinnerController._withIndex(this._index);

  int _index = -1;

  int get selectedIndex => _index;

  set selectedIndex(int value) {
    assert(value >= 0);
    _index = value;
    notifyListeners();
  }
}

typedef SpinnerItemBuilder = Widget Function(
    BuildContext context, int index, bool isEnabled);

class _SpinnerState extends State<Spinner> {
  int _index = -1;
  FocusNode? _focusNode;
  SpinnerController? _controller;

  SpinnerController get controller => widget.controller ?? _controller!;

  void _handleSelectedIndexUpdated() {
    setState(() {
      _index = controller.selectedIndex;
    });
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() {
    });
  }

  void _requestFocus() {
    _focusNode!.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(canRequestFocus: widget.isEnabled);
    // ignore: unnecessary_null_comparison
    if (widget.controller == null) {
      _controller = SpinnerController();
    }
    controller.addListener(_handleSelectedIndexUpdated);
    _index = controller.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.itemBuilder(context, _index, widget.isEnabled);
    content = GestureDetector(
      onTap: _requestFocus,
      child: Focus(
        focusNode: _focusNode,
        onFocusChange: _handleFocusChange,
        child: Semantics(
          enabled: widget.isEnabled,
          focusable: true,
          focused: _focusNode!.hasFocus,
          child: Padding(padding: EdgeInsets.all(1), child: content),
        ),
      ),
    );

    return SpinnerWidget(
      content: content,
      upButton: SpinnerButton(
        direction: 1,
        onTap: () {
          controller.selectedIndex++;
        },
      ),
      downButton: SpinnerButton(
          direction: -1,
          onTap: () {
            controller.selectedIndex--;
          }),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_handleSelectedIndexUpdated);
    if (_controller != null) {
      assert(widget.controller == null);
      _controller!.dispose();
    }
    _focusNode?.dispose();
    _focusNode = null;
    super.dispose();
  }
}

class SpinnerButton extends StatefulWidget {
  final int direction;
  final VoidCallback onTap;

  const SpinnerButton({Key? key, required this.direction, required this.onTap})
      : super(key: key);

  @override
  _SpinnerButtonState createState() => _SpinnerButtonState();
}

class _SpinnerButtonState extends State<SpinnerButton> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails details) {}

  void _handleTapUp(TapUpDetails details) {}

  void _handleTapCancel() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: HoverBuilder(
        builder: (BuildContext context, bool hover) {
          return CustomPaint(
            size: Size.fromWidth(11),
            painter: _SpinnerButtonPainter(
                direction: widget.direction,
                isHover: hover,
                isPressed: _pressed),
          );
        },
      ),
    );
  }
}

class SpinnerWidget extends RenderObjectWidget {
  final Widget content;
  final Widget upButton;
  final Widget downButton;

  SpinnerWidget(
      {required this.content,
      required this.upButton,
      required this.downButton});

  @override
  RenderObjectElement createElement() => SpinnerElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSpinner();
}

class SpinnerElement extends RenderObjectElement {
  SpinnerElement(SpinnerWidget widget) : super(widget);

  Element? _content;
  Element? _upButton;
  Element? _downButton;

  @override
  SpinnerWidget get widget => super.widget as SpinnerWidget;

  @override
  RenderSpinner get renderObject => super.renderObject as RenderSpinner;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_content != null) visitor(_content!);
    if (_upButton != null) visitor(_upButton!);
    if (_downButton != null) visitor(_downButton!);
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _content = updateChild(_content, widget.content, Slot.content);
    _upButton = updateChild(_upButton, widget.upButton, Slot.upButton);
    _downButton = updateChild(_downButton, widget.downButton, Slot.downButton);
  }

  @override
  void insertRenderObjectChild(RenderBox child, Slot slot) {
    switch (slot) {
      case Slot.content:
        renderObject.content = child;
        break;
      case Slot.upButton:
        renderObject.upButton = child;
        break;
      case Slot.downButton:
        renderObject.downButton = child;
        break;
    }
  }

  @override
  void removeRenderObjectChild(RenderObject child, Slot? slot) {
    // ignore: missing_enum_constant_in_switch
    switch (slot) {
      case Slot.content:
        renderObject.content = null;
        break;
      case Slot.upButton:
        renderObject.upButton = null;
        break;
      case Slot.downButton:
        renderObject.downButton = null;
        break;
    }
  }
}

class RenderSpinner extends RenderBox {
  static const Color baseColor = Color(0xffdddcd5);

  RenderBox? _content;

  RenderBox? get content => _content;

  set content(RenderBox? value) {
    if (value == _content) return;
    if (_content != null) dropChild(_content!);
    _content = value;
    if (_content != null) adoptChild(_content!);
  }

  RenderBox? _upButton;

  RenderBox? get upButton => _upButton;

  set upButton(RenderBox? value) {
    if (value == _upButton) return;
    if (_upButton != null) dropChild(_upButton!);
    _upButton = value;
    if (_upButton != null) adoptChild(_upButton!);
  }

  RenderBox? _downButton;

  RenderBox? get downButton => _downButton;

  set downButton(RenderBox? value) {
    if (value == _downButton) return;
    if (_downButton != null) dropChild(_downButton!);
    _downButton = value;
    if (_downButton != null) adoptChild(_downButton!);
  }

  @override
  void performLayout() {
    final double buttonWidth = math.min(
        upButton!.getMaxIntrinsicWidth(double.infinity),
        math.max(constraints.maxWidth - 3, 0));
    final BoxConstraints contentConstraints =
        constraints.deflate(EdgeInsets.only(left: buttonWidth + 3, top: 2));
    content!.layout(contentConstraints, parentUsesSize: true);

    final double buttonHeight = content!.size.height / 2;
    BoxConstraints buttonConstraints =
        BoxConstraints.tightFor(width: buttonWidth, height: buttonHeight);
    upButton!.layout(buttonConstraints);
    downButton!.layout(buttonConstraints);

    size = constraints.constrain(
        Size(content!.size.width + buttonWidth + 3, content!.size.height + 2));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(content != null);
    assert(upButton != null);
    assert(downButton != null);

    BoxParentData contentParentData = content!.parentData as BoxParentData;
    BoxParentData upButtonParentData = upButton!.parentData as BoxParentData;
    BoxParentData downButtonParentData =
        downButton!.parentData as BoxParentData;

    final double buttonWidth = upButton!.size.width;
    final double buttonHeight = upButton!.size.height;
    final Offset upButtonOffset = offset + upButtonParentData.offset;

    ui.Paint bgPaint = ui.Paint()
      ..shader = ui.Gradient.linear(
        upButton!.size.topCenter(upButtonOffset),
        upButton!.size.bottomCenter(upButtonOffset),
        <Color>[Colors.white70, baseColor],
      );
    final Rect bgRect = Rect.fromLTWH(
      offset.dx + upButtonParentData.offset.dx,
      offset.dy,
      buttonWidth,
      size.height,
    );
    context.canvas.drawRect(bgRect, bgPaint);

    context.paintChild(content!, offset + contentParentData.offset);
    context.paintChild(upButton!, upButtonOffset);
    context.paintChild(downButton!, offset + downButtonParentData.offset);

    ui.Paint paint = ui.Paint()
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xff999999);
    context.canvas.drawRect(
        Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1).shift(offset),
        paint);
    context.canvas.drawLine(
        offset + Offset(size.width - buttonWidth - 1.5, 0.5),
        offset + Offset(size.width - buttonWidth - 1.5, size.height - 1),
        paint);
    context.canvas.drawLine(
        offset + Offset(size.width - buttonWidth - 1.5, buttonHeight + 1.5),
        offset + Offset(size.width - 1, buttonHeight + 1.5),
        paint);
  }
}

enum Slot {
  content,
  upButton,
  downButton,
}

class _SpinnerButtonPainter extends CustomPainter {
  const _SpinnerButtonPainter({
    required this.direction,
    required this.isHover,
    required this.isPressed,
  });

  final int direction;
  final bool isHover;
  final bool isPressed;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // Paint the background.
    if (isPressed) {
      ui.Paint paint = ui.Paint()..color = const Color(0x80000000);
      canvas.drawRect(Offset.zero & size, paint);
    } else if (isHover) {
      ui.Paint paint = ui.Paint()..color = const Color(0x40000000);
      canvas.drawRect(Offset.zero & size, paint);
    }

    // Paint the image.
    canvas.translate((size.width - 5) / 2, (size.height - 5) / 2);
    if (direction > 0) {
      ui.Path path = ui.Path()
        ..moveTo(0, 4)
        ..lineTo(2.5, 1)
        ..lineTo(5, 4);
      ui.Paint paint = ui.Paint()..color = const Color(0xff000000);
      canvas.drawPath(path, paint);
    } else {
      ui.Path path = ui.Path()
        ..moveTo(0, 1)
        ..lineTo(2.5, 4)
        ..lineTo(5, 1);
      ui.Paint paint = ui.Paint()..color = const Color(0xff000000);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SpinnerButtonPainter oldDelegate) {
    return oldDelegate.direction != direction ||
        oldDelegate.isHover != isHover ||
        oldDelegate.isPressed != isPressed;
  }
}
