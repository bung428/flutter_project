import 'package:flutter_app_getx/page/crop/crop_controller.dart';
import 'package:get/get.dart';

class CropBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => CropTestController());
  }

}