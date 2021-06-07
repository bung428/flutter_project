import 'package:flutter/material.dart';

import 'crop_data.dart';

class CropGesture extends StatefulWidget {

  final CropGestureData data;

  const CropGesture({Key? key, required this.data}) : super(key: key);

  @override
  _CropGestureState createState() => _CropGestureState();
}

class _CropGestureState extends State<CropGesture>  with SingleTickerProviderStateMixin {

  final GlobalKey viewGlobalKey = GlobalKey();

  Matrix4 _gestureMatrix4 = Matrix4.identity();
  Matrix4? _matrix4;

  final double minViewScale = 0.8;
  final double maxViewScale = 20.0;

  late double _scaleStart;
  late double _scaleBase;
  late Offset _translateFromScene;
  // _ScaleGestureMatrixType? _scaleGestureMatrixType;

  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 2),vsync: this);
    _initMatrix();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CropGesture oldWidget) {
    if(widget.data != oldWidget.data) {
      _animation?.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
      _initMatrix();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initMatrix() {
    _gestureMatrix4 = Matrix4.identity()
      ..translate(widget.data.dx, widget.data.dy)..scale(widget.data.scale);
  }
}
