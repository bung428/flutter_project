import 'dart:ui'as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'crop_library.dart';

class CropPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CropPage> {
  final controller = CropController(aspectRatio: 3.0 / 4.0);
  double _rotation = 0;

  void _cropImage() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await controller.crop(pixelRatio: pixelRatio);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    final status = await Permission.storage.request();
                    if (status == PermissionStatus.granted) {
                      await _saveScreenShot(cropped);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Saved to gallery.'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          body: Center(
            child: RawImage(
              image: cropped,
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.link),
          onPressed: () {
            launch('https://github.com/xclud/flutter_crop');
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _cropImage,
            tooltip: 'Crop',
            icon: Icon(Icons.crop),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              // padding: EdgeInsets.all(8),
              child: Crop(
                onChanged: (decomposition) {
                  // if (_rotation != decomposition.rotation) {
                  //   setState(() {
                  //     _rotation = ((decomposition.rotation + 180) % 360) - 180;
                  //   });
                  // }

                  print("Scale : ${decomposition.scale}, Rotation: ${decomposition.rotation}, translation: ${decomposition.translation}");
                },
                controller: controller,
                child: Image.asset(
                  'assets/images/20191007_152848.jpg',
                  fit: BoxFit.cover,
                ),
                // foreground: IgnorePointer(
                //   child: Container(
                //     alignment: Alignment.bottomRight,
                //     child: Text(
                //       'Foreground Object',
                //       style: TextStyle(color: Colors.red),
                //     ),
                //   ),
                // ),
                // helper: shape == BoxShape.rectangle
                //     ? Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.white, width: 2),
                //   ),
                // )
                //     : null,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.undo),
                tooltip: 'Undo',
                onPressed: () {
                  controller.rotation = 0;
                  controller.scale = 1;
                  controller.offset = Offset.zero;
                  setState(() {
                    _rotation = 0;
                  });
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: theme.sliderTheme.copyWith(
                    trackShape: RectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    divisions: 360,
                    value: _rotation,
                    min: -180,
                    max: 180,
                    label: '$_rotation°',
                    onChanged: (n) {
                      setState(() {
                        _rotation = n.roundToDouble();
                        controller.rotation = _rotation;
                      });
                    },
                  ),
                ),
              ),
              PopupMenuButton<BoxShape>(
                icon: Icon(Icons.crop_free),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Box"),
                    value: BoxShape.rectangle,
                  ),
                  PopupMenuItem(
                    child: Text("Oval"),
                    value: BoxShape.circle,
                  ),
                ],
                tooltip: 'Crop Shape',
                onSelected: (x) {
                  setState(() {
                    // shape = x;
                  });
                },
              ),
              PopupMenuButton<double>(
                icon: Icon(Icons.aspect_ratio),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Original"),
                    value: 1000 / 667.0,
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    child: Text("16:9"),
                    value: 16.0 / 9.0,
                  ),
                  PopupMenuItem(
                    child: Text("4:3"),
                    value: 4.0 / 3.0,
                  ),
                  PopupMenuItem(
                    child: Text("1:1"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("3:4"),
                    value: 3.0 / 4.0,
                  ),
                  PopupMenuItem(
                    child: Text("9:16"),
                    value: 9.0 / 16.0,
                  ),
                ],
                tooltip: 'Aspect Ratio',
                onSelected: (x) {
                  print("KBG x : $x");
                  controller.aspectRatio = x;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> _saveScreenShot(ui.Image img) async {
  var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  var buffer = byteData!.buffer.asUint8List();
  final result = await ImageGallerySaver.saveImage(buffer);
  print(result);

  return result;
}