import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_getx/values/text_style.dart';
import 'package:flutter_app_getx/widget/transformations_demo_inertial_motion.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;


class CropGesture extends StatefulWidget {

  @override
  _CropGestureState createState() => _CropGestureState();
}

class _CropGestureState extends State<CropGesture>  with SingleTickerProviderStateMixin {

  final GlobalKey viewGlobalKey = GlobalKey();

  Matrix4 _matrix4 = Matrix4.identity();

  final double minViewScale = 0.8;
  final double maxViewScale = 20.0;

  double? _imageWidth;
  double? _imageHeight;

  late double _scaleStart;
  late double _scaleBase;
  late Offset _translateFromScene;
  double _oldRotate = 0.0;

  late AnimationController _controller;
  Animation<double>? _animation;

  ScaleGestureData? _centerInsideMatrix;

  _ScaleGestureMatrixType? _scaleGestureMatrixType;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 2),vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: viewGlobalKey,
        behavior: HitTestBehavior.opaque,
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Transform(
            transform: _matrix4,
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.red.withAlpha(0x3f),
              alignment: AlignmentDirectional.center,
              // helper.vector3ToOffset(_gestureMatrix4.getTranslation())
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/20191007_152848.jpg',
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                      if(_imageWidth == null || _imageHeight == null) {
                        if(child is Semantics) {
                          final rawImage = child.child;
                          if(rawImage is RawImage) {
                            _imageWidth = rawImage.image?.width.toDouble();
                            _imageHeight = rawImage.image?.height.toDouble();
                          }
                        }
                      }
                      final width = _imageWidth;
                      final height = _imageHeight;
                      if(width != null && height != null) {
                        return Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            AspectRatio(
                              aspectRatio: width / height,
                              child: Image.asset('assets/images/cameraAutoSampleBgColorTransparent.png', fit: BoxFit.cover),
                            ),
                            child,
                          ],
                        );
                      }

                      return child;
                    },
                  ),
                  Center(
                    child: Text('Offset : ${Offset(_matrix4.getTranslation().x, _matrix4.getTranslation().y)}\nScale : ${_matrix4
                        .getMaxScaleOnAxis()}\nRotate : ${_matrix4
                        .getRotation()}', style: textStyle.white500(20),),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  void onScaleStart(ScaleStartDetails details) {
    if (_centerInsideMatrix == null && _imageWidth != null && _imageHeight != null && viewGlobalKey.currentContext != null) {
      _centerInsideMatrix = ScaleGestureData.centerInside(viewGlobalKey.currentContext!.size!, Size(_imageWidth!, _imageHeight!));
      _animation?.removeListener(_onAnimate);
      _animation = null;
      _controller.reset();
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if(_centerInsideMatrix == null) {
      return;
    }

    double scale = _matrix4.getMaxScaleOnAxis();
    final Offset focalPointScene = fromViewport(
      details.localFocalPoint,
      _matrix4,
    );

    if(_scaleGestureMatrixType == null) {
      if (details.pointerCount == 1) {
        _scaleGestureMatrixType = _ScaleGestureMatrixType.TRANSITION;
        _translateFromScene = focalPointScene;
      }
      if(details.pointerCount > 1 && details.scale != 1.0) {
        print('KBG do scaling');
        // _scaleGestureMatrixType = _ScaleGestureMatrixType.SCALE;
        // _scaleStart = scale;
        // _scaleBase = details.scale;
      }
      if(details.pointerCount > 1 && details.rotation != 0.0) {
        print('KBG do rotation');
        double rotationDelta = details.rotation - _oldRotate;
        _oldRotate = details.rotation;
        var dx = (1 - cos(rotationDelta)) * details.localFocalPoint.dx + sin(rotationDelta) * details.localFocalPoint.dy;
        var dy = (1 - cos(rotationDelta)) * details.localFocalPoint.dy - sin(rotationDelta) * details.localFocalPoint.dx;
        _matrix4..rotateZ(rotationDelta)..translate(dx, dy);

        // setState(() {});
      }
      // if(details.pointerCount == 1) {
      //   _scaleGestureMatrixType = _ScaleGestureMatrixType.TRANSITION;
      //   _translateFromScene = focalPointScene;
      // } else if(details.pointerCount == 2) {
      //   _scaleGestureMatrixType = _ScaleGestureMatrixType.SCALE;
      //   _scaleStart = scale;
      //   _scaleBase = details.scale;
      // }
    }

    final type = _scaleGestureMatrixType;
    if(type != null) {
      switch(type) {
        case _ScaleGestureMatrixType.SCALE:
          final double desiredScale = _scaleStart * (1 - _scaleBase + details.scale);
          final double scaleChange = desiredScale / scale;
          _matrix4 = matrixScale(_matrix4, scaleChange, minViewScale, maxViewScale)!;
          final Offset focalPointSceneNext = fromViewport(
            details.localFocalPoint,
            _matrix4!,
          );
          Offset offset = focalPointSceneNext - focalPointScene;
          _matrix4.translate(offset.dx, offset.dy);
          // if (!widget.onScaled(true)) {
          setState(() {});
          // }
          break;
        case _ScaleGestureMatrixType.TRANSITION:
          final Offset translationChange = focalPointScene - _translateFromScene;
          _matrix4!.translate(translationChange.dx, translationChange.dy);
          // if (!widget.onScaled(true)) {
            setState(() {});
          // }
          break;
      }
    }

    // if(details.pointerCount == 1) {
    //   print('KBG pointer 1');
    //   _translateFromScene = focalPointScene;
    //
    //   final Offset translationChange = focalPointScene - _translateFromScene;
    //   _matrix4.translate(translationChange.dx, translationChange.dy);
    //   setState(() {});
    // }
    //
    // if (details.scale != 1.0) {
    //   _scaleStart = scale;
    //   _scaleBase = details.scale;
    //
    //   final double desiredScale = _scaleStart * (1 - _scaleBase + details.scale);
    //   final double scaleChange = desiredScale / scale;
    //   _matrix4 = matrixScale(_matrix4, scaleChange, minViewScale, maxViewScale)!;
    //   final Offset focalPointSceneNext = fromViewport(
    //     details.localFocalPoint,
    //     _matrix4,
    //   );
    //   Offset offset = focalPointSceneNext - focalPointScene;
    //   _matrix4.translate(offset.dx, offset.dy);
    //   setState(() {});
    // }
    //
    // if (details.rotation != 0.0) {
    //   double rotationDelta = details.rotation - _oldRotate;
    //   _oldRotate = details.rotation;
    //   _matrix4 = _rotate(_matrix4, rotationDelta, details.localFocalPoint);
    // }

    // setState(() {});
  }

  _MatrixAnimation? _beginMatrixAnimation;
  _MatrixAnimation? _endMatrixAnimation;

  void onScaleEnd(ScaleEndDetails details) {
    if(_centerInsideMatrix == null) {
      return;
    }

    if(_matrix4.getMaxScaleOnAxis() < 1.0) {
      _endAnimate(Offset.zero, 1);
    } else {
      final double velocityTotal = details.velocity.pixelsPerSecond.dx
          .abs()
          + details.velocity.pixelsPerSecond.dy.abs();
      Offset matrix4Offset = vector3ToOffset(_matrix4.getTranslation());
      final scaledOffset = _centerInsideMatrix!.offset * _matrix4.getMaxScaleOnAxis();
      final scaledSize = _centerInsideMatrix!.size * _matrix4.getMaxScaleOnAxis();

      if(velocityTotal != 0) {
        final InertialMotion inertialMotion = InertialMotion(
            details.velocity, matrix4Offset);
        matrix4Offset = inertialMotion.finalPosition;
        Offset limitedOffset = limitedLayoutOffset(
          _centerInsideMatrix!.layout, matrix4Offset + scaledOffset, scaledSize,);
        limitedOffset -= scaledOffset;
        _endAnimate(limitedOffset, _matrix4.getMaxScaleOnAxis());
      } else {
        Offset limitedOffset = limitedLayoutOffset(
          _centerInsideMatrix!.layout, matrix4Offset + scaledOffset, scaledSize,);
        limitedOffset -= scaledOffset;
        if(limitedOffset != matrix4Offset) {
          _endAnimate(limitedOffset, _matrix4.getMaxScaleOnAxis());
        }
      }
    }
    _centerInsideMatrix = null;
    _scaleGestureMatrixType = null;
  }

  void _endAnimate(Offset offset, double scale) {
    _beginMatrixAnimation = _MatrixAnimation(
        vector3ToOffset(_matrix4.getTranslation()),
        _matrix4.getMaxScaleOnAxis()
    );
    _endMatrixAnimation = _MatrixAnimation(offset, scale);
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

class _MatrixAnimation {
  final Offset offset;
  final double scale;

  _MatrixAnimation(this.offset, this.scale);
}

class ScaleGestureData {
  final Size layout;

  Offset offset;
  final Size size;
  double scale;

  ScaleGestureData(this.layout, this.offset, this.size, this.scale);

  factory ScaleGestureData.centerInside(Size layout, Size size) {
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
          scale
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
          scale
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

Matrix4 _rotate(Matrix4 matrix4, double angle, Offset focalPoint) {
  var c = cos(angle);
  var s = sin(angle);
  var dx = (1 - c) * focalPoint.dx + s * focalPoint.dy;
  var dy = (1 - c) * focalPoint.dy - s * focalPoint.dx;

  //  ..[0]  = c       # x scale
  //  ..[1]  = s       # y skew
  //  ..[4]  = -s      # x skew
  //  ..[5]  = c       # y scale
  //  ..[10] = 1       # diagonal "one"
  //  ..[12] = dx      # x translation
  //  ..[13] = dy      # y translation
  //  ..[15] = 1       # diagonal "one"
  // return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  return matrix4..rotateZ(angle)..translate(dx, dy);
}

enum _ScaleGestureMatrixType {
  SCALE,
  TRANSITION
}