import 'package:flutter/material.dart';
import 'package:flutter_app_getx/base/base_provider.dart';
import 'package:flutter_app_getx/page/home/home_controller.dart';

import 'package:flutter_app_getx/values/values.dart';
import 'package:flutter_app_getx/widget/touch_ink.dart';

import '../pages.dart';

// ignore: must_be_immutable
class AlbumPage extends BaseProvider<HomeController> {

  bool circleBoard = false;

  @override
  PreferredSizeWidget? appBar() => AppBar(
    backgroundColor: Colors.white,
    title: Text('Album', style: textStyle.black500(16),),
    leading: IconButton(icon: Icon(Icons.menu), onPressed: controller.showMenu, color: Colors.black,),
    actions: [
      IconButton(icon: Icon(Icons.mode_edit), onPressed: controller.deletePhotos, color: Colors.black,),
    ],
    elevation: 0.5,
    centerTitle: true,
  );

  @override
  Widget body(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: dimen(120),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: dimen(1),
                            color: Colors.black12
                        )
                    )
                ),
                child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return _buildImage();
                    }
                ),
              ),
              TextButton(onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => TestPAGe()));
              }, child: Text('button'))
            ],
          ),
        )
    );
  }

  Widget _buildImage() {
    return Container(
      padding: edgeInsets(all: dimen(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dimen(8)),
        child: TouchInk(
          onTap: () {

          },
          child: Container(
            width: dimen(100),
            height: dimen(88),
            decoration: BoxDecoration(
                border: Border.all(width: dimen(1)),
                borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Text('test'),
            ),
          ),
        ),
      ),
    );
  }

}