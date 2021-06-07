import 'dart:math';
import 'package:flutter_app_getx/page/crop/crop_controller.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter_app_getx/base/base_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app_getx/values/dimens.dart';
import 'package:flutter_app_getx/values/text_style.dart';
import 'package:flutter_app_getx/values/values.dart';
import 'package:flutter_app_getx/widget/space_widget.dart';


class CropTest extends GetView<CropTestController> {

  void _onPanUpdateHandler(DragUpdateDetails details) {
    final touchPositionFromCenter = details.localPosition;
    controller.setRotation(touchPositionFromCenter.direction);
    controller.cropController.rotation = controller.rotation.value;
    print('KBG _onPanUpdateHandler : ${touchPositionFromCenter.direction}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   flex: 1,
            //   child: Transform(
            //     alignment: Alignment.center,
            //     transform: Matrix4.identity()
            //       ..rotateZ(_rotation * pi / 180),
            //     child: FittedBox(
            //       child: Image.asset(
            //         'assets/images/20191007_152848.jpg',
            //         fit: BoxFit.cover,
            //       ),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    padding: edgeInsets(horizontal: dimen(8)),
                    child: GetBuilder<CropTestController>(
                      builder: (_) => CropView(
                        onChanged: (decomposition) {
                          if (_.rotation.value != decomposition.rotation) {
                            _.setRotation(((decomposition.rotation + 180) % 360) - 180);
                            // setState(() {
                            //   _rotation = ((decomposition.rotation + 180) % 360) - 180;
                            // });
                          }

                          print(
                              "Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                        },
                        controller: _.cropController,
                        child: Image.asset(
                          'assets/images/20191007_152848.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onScaleStart: (details) {
                      print('KBG onScaleStart : ${details.focalPoint}');
                    },
                    onScaleUpdate: (ScaleUpdateDetails details) {
                      print('KBG rotation : ${details.rotation}');
                      print('KBG pointerCount : ${details.pointerCount}');
                      print('KBG verticalScale : ${details.verticalScale}');
                      print('KBG horizontalScale : ${details.horizontalScale}');
                      print('KBG scale : ${details.scale}');
                      print('KBG focalPoint : ${details.focalPoint} x ${details.focalPoint.direction}');
                      print('KBG localFocalPoint : ${details.localFocalPoint} x ${details.localFocalPoint.direction}');
                    },
                  )
                ],
              ),
            ),
            ColSpace(height: dimen(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: () {}),
                IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: () {}),
                IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: () {}),
                IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: () {}),
              ],
            ),
            ColSpace(height: dimen(12)),
            SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                trackShape: RectangularSliderTrackShape(),
              ),
              child: Obx(() => Slider(
                divisions: 360,
                value: controller.rotation.value,
                min: -180,
                max: 180,
                label: '${controller.rotation.value}°',
                onChanged: (n) {
                  print("KBG onChanged : n : $n : n.roundToDouble() : ${n.roundToDouble()}");
                  controller.setRotation(n.roundToDouble());
                  controller.cropController.rotation = controller.rotation.value;
                  // setState(() {
                  //   _rotation = n.roundToDouble();
                  //   controller.rotation = _rotation;
                  // });
                },
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: () {}),
                  Text('Crop', style: textStyle.w400(dimen(14), Colors.white),),
                  IconButton(icon: Icon(Icons.check), color: Colors.white, onPressed: () {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CropView extends StatefulWidget {

  final Widget child;
  final CropController controller;
  final ValueChanged<MatrixDecomposition>? onChanged;

  const CropView({
    Key? key,
    required this.child,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  _CropViewState createState() => _CropViewState();
}

class _CropViewState extends State<CropView> with TickerProviderStateMixin {

  final _key = GlobalKey();
  final _parent = GlobalKey();
  final _repaintBoundaryKey = GlobalKey();

  double _previousScale = 1;
  Offset _previousOffset = Offset.zero;
  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;
  double _previousGestureRotation = 0.0;

  int _previousPointerCount = 0;

  late AnimationController _controller;
  late CurvedAnimation _animation;

  void _handleOnChanged() {
    print("KBG _handleOnChanged");
    widget.onChanged?.call(MatrixDecomposition(
        scale: widget.controller.scale,
        rotation: widget.controller.rotation,
        translation: widget.controller.offset));
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount > 1) {
      print("KBG _onScaleUpdate : pointerCount > 1");
      // In the first touch, we reset all the values.
      if (_previousPointerCount != details.pointerCount) {
        _previousPointerCount = details.pointerCount;
        _previousGestureRotation = 0.0;
      }

      // Instead of directly embracing the details.rotation, we need to
      // perform calculation to ensure that each round of rotation is smooth.
      // A user rotate the image using finger and release is considered as a
      // round. Without this calculation, the rotation degree of the image will
      // be reset.
      final gestureRotation = vm.degrees(details.rotation);

      // Within a round of rotation, the details.rotation is provided with
      // incremented value when user rotates. We don't need this, all we
      // want is the offset.
      final gestureRotationOffset = _previousGestureRotation - gestureRotation;

      // Remove the offset and constraint the degree scope to 0° <= degree <=
      // 360°. Constraint the scope is unnecessary, however, by doing this,
      // it would make our life easier when debugging.
      final rotationAfterCalculation =
          (widget.controller.rotation - gestureRotationOffset) % 360;

      /* details.rotation is in radians, convert this to degrees and set
        our rotation */
      widget.controller._rotation = rotationAfterCalculation;
      _previousGestureRotation = gestureRotation;
    }

    setState(() {});
    _handleOnChanged();
  }

  @override
  void initState() {
    //Setup animation.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(curve: Curves.easeInOut, parent: _controller);
    _animation.addListener(() {
      if (_animation.isCompleted) {
        // _reCenterImage(false);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.controller._scale * widget.controller._getMinScale();
    final o = Offset.lerp(_startOffset, _endOffset, _animation.value)!;
    final radians = widget.controller._rotation * pi / 180;
    print("KBG cropView : scale : $s");

    Widget _buildInnerCanvas() {
      final ip = IgnorePointer(
        key: _key,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(o.dx, o.dy, 0)
            ..rotateZ(radians)
            ..scale(1.0, 1.0, 1.0),
          child: FittedBox(
            child: widget.child,
            fit: BoxFit.cover,
          ),
        ),
      );

      List<Widget> widgets = [];

      // if (widget.background != null) {
      //   widgets.add(widget.background!);
      // }

      widgets.add(ip);

      // if (widget.foreground != null) {
      //   widgets.add(widget.foreground!);
      // }

      if (widgets.length == 1) {
        return ip;
      } else {
        return Stack(
          fit: StackFit.expand,
          children: widgets,
        );
      }
    }

    Widget _buildRepaintBoundary() {
      final repaint = RepaintBoundary(
        key: _repaintBoundaryKey,
        child: _buildInnerCanvas(),
      );

      // if (widget.helper == null) {
      //   return repaint;
      // }

      return Stack(
        fit: StackFit.expand,
        children: [
          repaint,
          // widget.helper!
        ],
      );
    }

    final gd = GestureDetector(
      onScaleStart: (details) {
        _previousOffset = details.focalPoint;
        _previousScale = max(widget.controller._scale, 1);
      },
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: (details) {
        widget.controller._scale = max(widget.controller._scale, 1);
        _previousPointerCount = 0;
        // _reCenterImage();
      },
    );

    List<Widget> over = [
      CropRenderObjectWidget(
        aspectRatio: widget.controller._aspectRatio,
        backgroundColor: Colors.black,
        shape: BoxShape.rectangle,
        // dimColor: Color.fromRGBO(0, 0, 0, 0.8),
        dimColor: Color.fromRGBO(0, 0, 0, 0.8),
        child: _buildRepaintBoundary(),
      ),
    ];

    // if (widget.overlay != null) {
    //   over.add(widget.overlay!);
    // }
    //
    // if (widget.interactive) {
    //   over.add(gd);
    // }

    return ClipRect(
      key: _parent,
      child: Stack(
        fit: StackFit.expand,
        children: over,
      ),
    );
  }
}

typedef _CropCallback = Future<ui.Image> Function(double pixelRatio);

class CropController extends ChangeNotifier {
  double _aspectRatio = 1;
  double _rotation = 0;
  double _scale = 1;
  Offset _offset = Offset.zero;
  _CropCallback? _cropCallback;

  double get aspectRatio => _aspectRatio;

  set aspectRatio(double value) {
    _aspectRatio = value;
    notifyListeners();
  }

  double get scale => max(_scale, 1);

  set scale(double value) {
    _scale = max(value, 1);
    notifyListeners();
  }

  double get rotation => _rotation;

  /// Sets the desired rotation.
  set rotation(double value) {
    _rotation = value;
    notifyListeners();
  }

  Offset get offset => _offset;

  set offset(Offset value) {
    _offset = value;
    notifyListeners();
  }

  Matrix4 get transform => Matrix4.identity()
    ..translate(_offset.dx, _offset.dy, 0)
    ..rotateZ(_rotation)
    ..scale(_scale, _scale, 1);

  CropController({
    double aspectRatio: 1.0,
    double scale: 1.0,
    double rotation: 0,
  }) {
    _aspectRatio = aspectRatio;
    _scale = scale;
    _rotation = rotation;
  }

  double _getMinScale() {
    final r = vm.radians(_rotation % 360);
    final rabs = r.abs();

    final sinr = sin(rabs).abs();
    final cosr = cos(rabs).abs();

    final x = cosr * _aspectRatio + sinr;
    final y = sinr * _aspectRatio + cosr;

    final m = max(x / _aspectRatio, y);

    return m;
  }

  Future<ui.Image> crop({double pixelRatio: 1}) {
    if (_cropCallback == null) {
      return Future.value(null);
    }

    return _cropCallback!.call(pixelRatio);
  }
}

class MatrixDecomposition {

  final double rotation;
  final double scale;
  final Offset translation;

  MatrixDecomposition({
    required this.scale,
    required this.rotation,
    required this.translation,
  });

}

class CropRenderObjectWidget extends SingleChildRenderObjectWidget {
  final Key? key;
  final double aspectRatio;
  final Color dimColor;
  final Color backgroundColor;
  final BoxShape shape;

  CropRenderObjectWidget({
    required Widget child,
    required this.aspectRatio,
    required this.shape,
    this.key,
    this.backgroundColor: Colors.black,
    this.dimColor: const Color.fromRGBO(0, 0, 0, 0.8),
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCrop()
      ..aspectRatio = aspectRatio
      ..dimColor = dimColor
      ..backgroundColor = backgroundColor
      ..shape = shape;
  }

  @override
  void updateRenderObject(BuildContext context, RenderCrop renderObject) {
    bool needsPaint = false;
    bool needsLayout = false;

    if (renderObject.aspectRatio != aspectRatio) {
      renderObject.aspectRatio = aspectRatio;
      needsLayout = true;
    }

    if (renderObject.dimColor != dimColor) {
      renderObject.dimColor = dimColor;
      needsPaint = true;
    }

    if (renderObject.shape != shape) {
      renderObject.shape = shape;
      needsPaint = true;
    }

    if (renderObject.backgroundColor != backgroundColor) {
      renderObject.backgroundColor = backgroundColor;
      needsPaint = true;
    }

    if (needsLayout) {
      renderObject.markNeedsLayout();
    }
    if (needsPaint) {
      renderObject.markNeedsPaint();
    }

    super.updateRenderObject(context, renderObject);
  }
}

class RenderCrop extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  double? aspectRatio;
  Color? dimColor;
  Color? backgroundColor;
  BoxShape? shape;

  @override
  bool hitTestSelf(Offset position) => false;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    size = constraints.biggest;

    if (child != null) {
      final forcedSize =
      _getSizeToFitByRatio(aspectRatio!, size.width, size.height);
      child!.layout(BoxConstraints.tight(forcedSize), parentUsesSize: true);
    }
  }

  Path _getDimClipPath() {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final forcedSize =
    _getSizeToFitByRatio(aspectRatio!, size.width, size.height);
    Rect rect = Rect.fromCenter(
        center: center, width: forcedSize.width, height: forcedSize.height);

    final path = Path();
    if (shape == BoxShape.circle) {
      path.addOval(rect);
    } else if (shape == BoxShape.rectangle) {
      path.addRect(rect);
    }

    path.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {}

  void paint(PaintingContext context, Offset offset) {
    final bounds = offset & size;

    if (backgroundColor != null) {
      context.canvas.drawRect(bounds, Paint()..color = backgroundColor!);
    }

    final forcedSize =
    _getSizeToFitByRatio(aspectRatio!, size.width, size.height);

    if (child != null) {
      final Offset tmp = (size - forcedSize) as Offset;
      context.paintChild(child!, offset + tmp / 2);

      final clipPath = _getDimClipPath();

      context.pushClipPath(
        needsCompositing,
        offset,
        bounds,
        clipPath,
            (context, offset) {
          context.canvas.drawRect(bounds, Paint()..color = dimColor!);
        },
      );
    }
  }
}

Size _getSizeToFitByRatio(
    double imageAspectRatio, double containerWidth, double containerHeight) {
  var targetAspectRatio = containerWidth / containerHeight;

  // no need to adjust the size if current size is square
  var adjustedWidth = containerWidth;
  var adjustedHeight = containerHeight;

  // get the larger aspect ratio of the two
  // if aspect ratio is 1 then no adjustment needed
  if (imageAspectRatio > targetAspectRatio) {
    adjustedHeight = containerWidth / imageAspectRatio;
  } else if (imageAspectRatio < targetAspectRatio) {
    adjustedWidth = containerHeight * imageAspectRatio;
  }

  // set the adjusted size (same if square)
  return Size(adjustedWidth, adjustedHeight);
}

