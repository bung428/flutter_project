import 'package:flutter/material.dart';
import 'package:flutter_app_getx/values/text_style.dart';
import 'package:flutter_app_getx/values/values.dart';
import 'package:flutter_app_getx/widget/space_widget.dart';
import 'package:flutter_app_getx/widget/touch_ink.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'crop_gesture.dart';

class CropByGooPage extends StatefulWidget {

  final double imageWidth;
  final double imageHeight;

  const CropByGooPage({Key? key, required this.imageWidth, required this.imageHeight}) : super(key: key);

  @override
  _CropByGooPageState createState() => _CropByGooPageState();
}

class _CropByGooPageState extends State<CropByGooPage> {

  final _cropKey = GlobalKey();

  static const double menuHeight = 144;

  double? _aspectRatio;


  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.imageWidth / widget.imageHeight;
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildRatioItem(int index) {
      return TouchInk(
        child: Container(
          padding: edgeInsets(all: dimen(8)),
          width: dimen(64),
          child: Column(
            children: [
              Icon(Icons.cancel_outlined, color: Colors.white, size: dimen(36),),
              ColSpace(height: dimen(8)),
              Text('${CropRatio.values[index].strRatio}', style: textStyle.white300(14),)
            ],
          ),
        ),
        onTap: () {
          setState(() {
            if (index == 0) {
              _aspectRatio = widget.imageWidth / widget.imageHeight;
            } else {
              _aspectRatio = CropRatio.values[index].aspectRatio;
            }
          });
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double _menuHeight;
            if(constraints.maxHeight - constraints.maxWidth * 4 / 3 > menuHeight) {
              _menuHeight = constraints.maxHeight - constraints.maxWidth * 4 / 3;
            } else {
              _menuHeight = menuHeight;
            }
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: CropGesture(
                    key: _cropKey,
                    ratio: _aspectRatio!,
                  ),
                ),
                Container(
                  padding: edgeInsets(horizontal: dimen(12)),
                  height: _menuHeight,
                  color: Colors.black,
                  child: Column(
                    children: [
                      Spacer(flex: 1,),
                      Container(
                        height: dimen(88),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: CropRatio.values.length,
                          itemBuilder: (context, index) {
                            return _buildRatioItem(index);
                          }
                        ),
                      ),
                      Spacer(flex: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: Icon(Icons.cancel_outlined), color: Colors.white, onPressed: () {}),
                          Text('Crop', style: textStyle.w400(dimen(14), Colors.white),),
                          IconButton(icon: Icon(Icons.check), color: Colors.white, onPressed: () {}),
                        ],
                      ),
                      Spacer(flex: 1,),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CropGesture extends StatefulWidget {

  final bool shouldTranslate;
  final bool shouldScale;
  final bool shouldRotate;
  final double ratio;

  const CropGesture({
    Key? key,
    required this.ratio,
    this.shouldTranslate = true,
    this.shouldScale = true,
    this.shouldRotate = true,
  }) : super(key: key);

  @override
  _CropGestureState createState() => _CropGestureState();
}

class _CropGestureState extends State<CropGesture>  with SingleTickerProviderStateMixin {

  final GlobalKey viewGlobalKey = GlobalKey();

  Matrix4 _matrix4 = Matrix4.identity();

  final double minViewScale = 0.8;
  final double maxViewScale = 20.0;

  late double _previousScale;
  double _rotation = 0.0;
  double? _imageWidth;
  double? _imageHeight;

  late AnimationController _controller;
  Animation<double>? _animation;

  ScaleGestureData? _centerInsideMatrix;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 2),vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _child () {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cameraAutoSampleBgColorTransparent.png',),
                  fit: BoxFit.cover,
                )
            ),
            child: Transform(
              transform: _matrix4,
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/20191007_152848.jpg',
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if(_imageWidth == null || _imageHeight == null) {
                    if(child is Semantics) {
                      final rawImage = child.child;
                      if(rawImage is RawImage) {
                        _imageWidth = rawImage.image?.width.toDouble();
                        _imageHeight = rawImage.image?.height.toDouble();
                        print('KBG w : $_imageWidth : h : $_imageHeight');
                        // _aspectRatio = (_imageWidth ?? 1.0) / (_imageHeight ?? 1.0);
                      }
                    }
                  }
                  final width = _imageWidth;
                  final height = _imageHeight;
                  if(width != null && height != null) {
                    return Stack(
                      children: [
                        child,
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Offset : ${Offset(_matrix4.getTranslation().x, _matrix4.getTranslation().y)}'
                                  '\nScale : ${_matrix4.getMaxScaleOnAxis()}',
                              style: textStyle.white500(20),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return child;
                },
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        GestureDetector(
          key: viewGlobalKey,
          behavior: HitTestBehavior.opaque,
          onScaleStart: onScaleStart,
          onScaleUpdate: onScaleUpdate,
          onScaleEnd: onScaleEnd,
          child: _child(),
        ),
        CropRenderObjectWidget(
          aspectRatio: widget.ratio,
          backgroundColor: Colors.transparent,
          shape: BoxShape.rectangle,
          dimColor: Colors.black.withOpacity(0.6),
          child: Container(),
        ),
      ],
    );
  }

  _ValueUpdater<double> scaleUpdater = _ValueUpdater(
    value: 1.0,
    onUpdate: (oldVal, newVal) => newVal / oldVal,
  );
  _ValueUpdater<double> rotationUpdater = _ValueUpdater(
    value: 0.0,
    onUpdate: (oldVal, newVal) => newVal - oldVal,
  );

  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;

  void onScaleStart(ScaleStartDetails details) {
    final Offset focalPointScene = fromViewport(
      details.localFocalPoint,
      _matrix4,
    );
    _startOffset = focalPointScene;

    double scale = _matrix4.getMaxScaleOnAxis();
    _previousScale = scale;
    scaleUpdater.value = scale;

    rotationUpdater.value = _rotation;

    if (_centerInsideMatrix == null && viewGlobalKey.currentContext != null && _imageWidth != null && _imageHeight != null) {
      _centerInsideMatrix = ScaleGestureData.centerInside(viewGlobalKey.currentContext!.size!, Size(_imageWidth!, _imageHeight!), _rotation);
      _animation?.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if(_centerInsideMatrix == null) {
      return;
    }

    final Offset focalPointScene = fromViewport(
      details.localFocalPoint,
      _matrix4,
    );
    _endOffset = focalPointScene;

    if (details.pointerCount < 2) {
      Offset translationChange = _endOffset - _startOffset;
      _matrix4.translate(translationChange.dx, translationChange.dy);

      setState(() {});
    }

    if (details.scale != 1.0) {
      double scaleDelta = scaleUpdater.update(_previousScale * details.scale);
      _matrix4.scale(scaleDelta);
      final Offset focalPointSceneNext = fromViewport(
        details.localFocalPoint,
        _matrix4,
      );
      Offset offset = focalPointSceneNext - focalPointScene;
      _matrix4.translate(offset.dx, offset.dy);

      setState(() {});
      // double scale = _matrix4.getMaxScaleOnAxis();
      // _previousScale = scale;
    }

    if (details.rotation != 0.0) {
      double rotationDelta = rotationUpdater.update(details.rotation);
      _matrix4.rotateZ(rotationDelta);
      print('KBG scaleUpd rot : $rotationDelta');
      final Offset focalPointSceneNext = fromViewport(
        details.localFocalPoint,
        _matrix4,
      );
      Offset offset = focalPointSceneNext - focalPointScene;
      _matrix4.translate(offset.dx, offset.dy);

      setState(() {});
      _rotation = rotationDelta;
    }

    // _currentPointerCnt = details.pointerCount;
  }

  _MatrixAnimation? _beginMatrixAnimation;
  _MatrixAnimation? _endMatrixAnimation;

  void onScaleEnd(ScaleEndDetails details) {
    if(_centerInsideMatrix == null) {
      return;
    }

    print('-----------------------------------------------------------------------------------------------');
    print('KBG scaleEnd rot : $_rotation');
    print('KBG scaleEnd scale : ${_matrix4.getMaxScaleOnAxis()}');

    if(_matrix4.getMaxScaleOnAxis() <= 1.0) {
      _endAnimate(Offset.zero, 1.0, _rotation);
      _matrix4.rotateZ(0.123423);
      setState(() {

      });
    }
    // else {
    //   final double velocityTotal = details.velocity.pixelsPerSecond.dx.abs()
    //       + details.velocity.pixelsPerSecond.dy.abs();
    //   Offset matrix4Offset = vector3ToOffset(_matrix4.getTranslation());
    //   final scaledOffset = _centerInsideMatrix!.offset * _matrix4.getMaxScaleOnAxis();
    //   final scaledSize = _centerInsideMatrix!.size * _matrix4.getMaxScaleOnAxis();
    //
    //   final Offset offset = fromViewport(
    //     vector3ToOffset(_matrix4.getTranslation()),
    //     _matrix4,
    //   );
    //
    //
    //   print('KBG offset : dx : ${offset.dx}');
    //   print('KBG offset : dy : ${offset.dy}');
    //   // final width = (scaledSize.width - _centerInsideMatrix!.size.width);
    //   // final height = (scaledSize.height - _centerInsideMatrix!.size.height);
    //   // print('KBG _centerInsideMatrix!.size : ${_centerInsideMatrix!.size}');
    //   // print('KBG scaledSize : $scaledSize');
    //   // print('KBG width : $width');
    //   // print('KBG height : $height');
    //   // _matrix4.translate(offset.dx / 2, offset.dy / 2);
    //
    //
    //   if (_currentPointerCnt > 1) {
    //
    //   }
    //   // } else {
    //   //   final width = (scaledSize.width - _centerInsideMatrix!.size.width);
    //   //   final height = (scaledSize.height - _centerInsideMatrix!.size.height);
    //   //   print('KBG _centerInsideMatrix!.size : ${_centerInsideMatrix!.size}');
    //   //   print('KBG scaledSize : $scaledSize');
    //   //   print('KBG width : $width');
    //   //   print('KBG height : $height');
    //   // }
    //   // _matrix4.translate(_matrix4.getTranslation().x / 2, _matrix4.getTranslation().y / 2);
    //   setState(() {});
    //
    //   if(velocityTotal != 0) {
    //     final InertialMotion inertialMotion = InertialMotion(
    //         details.velocity, matrix4Offset);
    //     matrix4Offset = inertialMotion.finalPosition;
    //     // Offset limitedOffset = limitedLayoutOffset(_centerInsideMatrix!.layout, matrix4Offset + scaledOffset, scaledSize,);
    //     // limitedOffset -= scaledOffset;
    //     // _endAnimate(limitedOffset, _matrix4.getMaxScaleOnAxis(), _rotation);
    //   } else {
    //     Offset limitedOffset = limitedLayoutOffset(
    //       _centerInsideMatrix!.layout, matrix4Offset + scaledOffset, scaledSize,);
    //     limitedOffset -= scaledOffset;
    //     if(limitedOffset != matrix4Offset) {
    //       // _endAnimate(limitedOffset, _matrix4.getMaxScaleOnAxis(), _rotation);
    //       // _matrix4.translate(limitedOffset.dx, limitedOffset.dy);
    //     }
    //   }
    // }
    _centerInsideMatrix = null;

  }

  void _endAnimate(Offset offset, double scale, double rotation) {
    _beginMatrixAnimation = _MatrixAnimation(
        vector3ToOffset(_matrix4.getTranslation()),
        _matrix4.getMaxScaleOnAxis(),
        _rotation
    );
    _endMatrixAnimation = _MatrixAnimation(offset, scale, rotation);
    _animation?.removeListener(_onAnimate);
    _controller.reset();
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    _animation!.addListener(_onAnimate);
    _controller.fling();
  }

  void _onAnimate() {
    final animation = _animation;
    final begin = _beginMatrixAnimation;
    final end = _endMatrixAnimation;
    if(animation != null && begin != null && end != null) {
      setState(() {
        Offset offset = begin.offset * (1 - _animation!.value) + end.offset * _animation!.value;
        double scale = begin.scale * (1 - _animation!.value) + end.scale * _animation!.value;
        // _matrix4 = Matrix4.identity()..rotateZ(rotation)..scale(scale
        _matrix4 = Matrix4.identity()..translate(offset.dx, offset.dy)..scale(scale);
        if(!_controller.isAnimating) {
          _animation?.removeListener(_onAnimate);
          _animation = null;
          _controller.reset();
          if(scale == 1) {
            // widget.onScaled(false);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CropGesture oldWidget) {
    if(widget != oldWidget) {
      _animation?.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
    }
    super.didUpdateWidget(oldWidget);
  }

}

typedef _OnUpdate<T> = T Function(T oldValue, T newValue);

class _ValueUpdater<T> {
  final _OnUpdate<T> onUpdate;
  T value;

  _ValueUpdater({
    required this.value,
    required this.onUpdate,
  });

  T update(T newValue) {
    T updated = onUpdate(value, newValue);
    value = newValue;
    return updated;
  }
}

class _MatrixAnimation {
  final Offset offset;
  final double scale;
  final double rotation;

  _MatrixAnimation(this.offset, this.scale, this.rotation);
}

class ScaleGestureData {
  final Size layout;

  Offset offset;
  final Size size;
  double scale;
  double rotation;

  ScaleGestureData(this.layout, this.offset, this.size, this.scale, this.rotation);

  factory ScaleGestureData.centerInside(Size layout, Size size, double rotation) {
    double layoutRatio = layout.width / layout.height;
    double contentRatio = size.width / size.height;
    if(layoutRatio > contentRatio) {
      double scale = layout.height / size.height;
      double width = size.width * scale;
      double height = layout.height;
      double dx = (layout.width - width) / 2;
      double dy = 0;
      return ScaleGestureData(
          layout,
          Offset(dx, dy),
          Size(width, height),
          scale,
          rotation
      );
    } else {
      double scale = layout.width / size.width;
      double width = layout.width;
      double height = size.height * scale;
      double dx = 0;
      double dy = (layout.height - height) / 2;
      return ScaleGestureData(
          layout,
          Offset(dx, dy),
          Size(width, height),
          scale,
          rotation
      );
    }
  }

  Matrix4 get matrix4 => Matrix4.identity()
    ..translate(offset.dx, offset.dy)
    ..scale(scale);

}

Matrix4? matrixScale(Matrix4? matrix, double scale, double min, double max) {
  if (scale == 1) {
    return matrix;
  }
  assert(scale != 0);

  // Don't allow a scale that results in an overall scale beyond min/max
  // scale.
  final double currentScale = matrix!.getMaxScaleOnAxis();
  final double totalScale = currentScale * scale;
  final double clampedTotalScale = totalScale.clamp(
    min,
    max,
  );
  final double clampedScale = clampedTotalScale / currentScale;
  return matrix..scale(clampedScale);
}

Offset fromViewport(Offset viewportPoint, Matrix4 transform) {
  final Matrix4 inverseMatrix = Matrix4.inverted(transform);
  final Vector3 untransformed = inverseMatrix.transform3(Vector3(
    viewportPoint.dx,
    viewportPoint.dy,
    0,
  ));
  return Offset(untransformed.x, untransformed.y);
}

Offset vector3ToOffset(Vector3 vector3) {
  return Offset(vector3.x, vector3.y);
}

Offset limitedLayoutOffset(Size layout, Offset offset, Size size) {
  double dx = offset.dx;
  double dy = offset.dy;

  if(layout.width > size.width) {
    dx = (layout.width - size.width) / 2;
  } else {
    if(layout.width > dx + size.width) {
      dx = layout.width - size.width;
    } else if(dx > 0) {
      dx = 0;
    }
  }

  if(layout.height > size.height) {
    dy = (layout.height - size.height) / 2;
  } else {
    if(layout.height > dy + size.height) {
      dy = layout.height - size.height;
    } else if(dy > 0) {
      dy = 0;
    }
  }

  return Offset(dx, dy);
}


