import 'package:flutter_app_getx/base/base_controller.dart';
import 'package:flutter_app_getx/util/log.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  var count = 0.obs;
  var page1factor = 1.0.obs;
  var page2factor = 1.0.obs;
  var rotation = 1.0.obs;

  void showMenu() {
    print('KBG');
    // Log.i();
  }

  void setRotation(double value) {

  }

  void deletePhotos() {

  }

  void increment() {
    count++;
    update();
  }

  void test() {
    page1factor.value = 0.7;
    page2factor.value = 0.8;
    update();
  }

  void close() {
    page1factor.value = 1.0;
    page2factor.value = 1.0;
    update();
  }


}