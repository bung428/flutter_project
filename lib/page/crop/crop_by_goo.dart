import 'package:flutter/material.dart';
import 'package:flutter_app_getx/values/text_style.dart';
import 'package:flutter_app_getx/values/values.dart';
import 'package:flutter_app_getx/widget/space_widget.dart';
import 'package:flutter_app_getx/widget/touch_ink.dart';

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
  // final controller = CropGestureController(aspectRatio: 3.0 / 4.0);

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
                    // controller: controller,
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


