import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app_getx/base/base_provider.dart';
import 'package:flutter_app_getx/page/crop/crop_by_goo.dart';
import 'package:flutter_app_getx/page/crop/crop_controller.dart';
import 'package:flutter_app_getx/widget/animation_list.dart';
import 'package:flutter_app_getx/widget/custom_side_navbar.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'home_controller.dart';


class Dummy {
  final String name;
  final String phone;
  final String email;

  Dummy(this.name, this.phone, this.email);
}

// ignore: must_be_immutable
class Home extends BaseProvider<HomeController> {
  @override
  PreferredSizeWidget? appBar() => null;

  var _list = <Dummy>[
    Dummy('aaa', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('bbb', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('ccc', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('ddd', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('fff', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('ggg', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('hhh', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('iii', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('jjj', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('kkk', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('lll', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('mmm', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('nnn', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('ooo', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('ppp', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('qqq', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('rrr', '010 1010 1010', 'bgk@storecamera.io'),
    Dummy('sss', '010 1010 1010', 'bgk@storecamera.io'),
  ];
  final listKey = GlobalKey<AnimatedListState>();

  void insert() {
    final state = listKey.currentState;
    if (state != null) {
      state.insertItem(
          0,
          duration: const Duration(milliseconds: 500)
      );
      _list = [Dummy('test', 'test', 'test'),..._list];
    }
  }

  void remove() {
    final state = listKey.currentState;
    if (state != null) {
      // state.removeItem(
      //     0, (_, animation) => slideIt(context, 0, animation),
      //     duration: const Duration(milliseconds: 500));
      // _items.removeAt(0);
    }
  }

  // Future<void> _loadItems() async {
    // for (int item in _fetchedItems) {
    //   // 1) Wait for one second
    //   await Future.delayed(Duration(milliseconds: 1000));
    //   // 2) Adding data to actual variable that holds the item.
    //   _items.add(item);
    //   // 3) Telling animated list to start animation
    //   listKey.currentState.insertItem(_items.length - 1);
    // }
  // }

  @override
  Widget body(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            width: Get.width,
            height: Get.height,
            child: Stack(
              children: [
                SideNavBar(close: controller.close, start: controller.page1factor.value == 1.0 ? false : true),
                AnimatedPositioned(
                    left: controller.page2factor.value == 1.0 ? 0.0 : 200.0,
                    top: controller.page1factor.value == 1.0 ? 0.0 : 85.0,
                    child: AnimatedContainer(
                      height: Get.height * controller.page2factor.value,
                      width: Get.width * controller.page2factor.value,
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    duration: Duration(milliseconds: 300)
                ),
                AnimatedPositioned(
                    left: controller.page1factor.value == 1.0 ? 0.0 : 250.0,
                    top: controller.page1factor.value == 1.0 ? 0.0 : 130.0,
                    child: AnimatedContainer(
                      height: Get.height * controller.page1factor.value,
                      width: Get.width * controller.page1factor.value,
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: controller.page1factor.value == 1.0 ? null : BorderRadius.circular(20)
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          AppBar(
                            elevation: 0.0,
                            backgroundColor: Colors.white,
                            leading: IconButton(
                              icon: Icon(Icons.menu, color: Colors.black,),
                              onPressed: () => controller.test(),
                            ),
                          ),
                          AnimationList(
                              listKey: listKey,
                              items: _list,
                              itemBuilder: (context, index, animation) {
                                final type = AnimationType.slide;
                                final child = Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Text(_list[index].name),
                                              Text(_list[index].email),
                                            ],
                                          )
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Text(_list[index].phone)
                                      )
                                    ],
                                  ),
                                );
                                return AnimationTypeExt.from(type, animation, child);
                              }
                          ),
                        ],
                      ),
                    ),
                    duration: Duration(milliseconds: 300)
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: TextButton(
                          onPressed: () => Get.to(() => Test()),
                          child: Text('test'))
                      ),
                      Expanded(flex: 1, child: TextButton(
                          onPressed: () => Get.toNamed('/crop'),
                          child: Text('crop test'))
                      ),
                      Expanded(flex: 1, child: TextButton(onPressed: insert, child: Text('insert'))),
                      Expanded(flex: 1, child: TextButton(onPressed: remove, child: Text('remove'))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

class Test extends GetView<CropTestController> {
  // @override
  // PreferredSizeWidget? appBar() => null;
  //
  // @override
  // Widget body(BuildContext context) {
  //   return Text('hi');
  // }

  @override
  Widget build(BuildContext context) {
    return Text('hi');
  }

}

class TestPAGe extends StatefulWidget {
  @override
  _TestPAGeState createState() => _TestPAGeState();
}

class _TestPAGeState extends State<TestPAGe> {
  List<AssetEntity> _mediaList = [];
  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }
  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> media = await albums[0].getAssetListPaged(0, 20);
      print(media);
      setState(() {
        _mediaList = media;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: _mediaList.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
            future: _mediaList[index].thumbDataWithSize(200, 200),
            builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Image.memory(
                  snapshot.data!,
                );
              return Container();
            },
          );
        });
  }
}