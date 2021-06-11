import 'package:flutter_app_getx/page/about/about_page.dart';
import 'package:flutter_app_getx/page/bindings.dart';
import 'package:flutter_app_getx/page/crop/crop_by_goo.dart';
import 'package:flutter_app_getx/page/pages.dart';
import 'package:flutter_app_getx/resume_page.dart';
import 'package:flutter_app_getx/values/values.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';



void main() => runApp(GetxTestApp());

class GetxTestApp extends StatefulWidget {
  @override
  _GetxTestAppState createState() => _GetxTestAppState();
}

class _GetxTestAppState extends State<GetxTestApp> {

  bool initMediaQuery = false;

  @override
  Widget build(BuildContext context) {

    if(!initMediaQuery) {
      initMediaQuery = true;
      if (GetPlatform.isAndroid) {
        dimenUnit = Get.width >= 411 ? 411 / 360 : 1.0;
      } else if (GetPlatform.isIOS) {
        dimenUnit = 1.0;
      } else if (GetPlatform.isWeb) {
        print("KBG : isWeb : ${Get.width}");
      } else if (GetPlatform.isDesktop) {
        print("KBG : isDesktop : ${Get.width}");
      }
      // R.devicePixelRatio = mediaQuery.devicePixelRatio;
    }

    return GetMaterialApp(
      title: 'GetXTestApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialBinding: HomeBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => Home(),
            binding: HomeBinding()
        ),
        GetPage(
            name: '/contact',
            page: () => ContactPage(),
            binding: HomeBinding()
        ),
        GetPage(
            name: '/blog',
            page: () => BlogPage(),
            binding: HomeBinding()
        ),
        GetPage(
            name: '/resume',
            page: () => ResumePage(),
            binding: HomeBinding()
        ),
        GetPage(
            name: '/about',
            page: () => AboutPage(),
            binding: HomeBinding()
        ),
        GetPage(
            name: '/crop_by_goo',
            page: () => CropByGooPage(imageWidth: 3024.0, imageHeight: 4032.0,),
            binding: CropBinding()
        ),
      ],
    );
  }
}

