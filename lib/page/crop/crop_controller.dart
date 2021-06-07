import 'package:flutter_app_getx/base/base_controller.dart';
import 'package:get/get.dart';

import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vm;

import 'crop_by_goo.dart';

class CropTestController extends GetxController {
  var rotation = 0.0.obs;

  // final cropController = CropController(aspectRatio: 1000 / 667.0);

  void setRotation(double value) {
    rotation.value = value;
    update();
  }

  double getMinScale() {
    final r = vm.radians(rotation.value % 360);
    final rabs = r.abs();

    final sinr = sin(rabs).abs();
    final cosr = cos(rabs).abs();

    final x = cosr * 1 + sinr;
    final y = sinr * 1 + cosr;

    final m = max(x / 1, y);

    return m;
  }

}