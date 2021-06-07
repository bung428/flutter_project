import 'package:flutter/material.dart';
import 'package:flutter_app_getx/page/pages.dart';
import 'package:flutter_app_getx/widget/touch_ink.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'space_widget.dart';
import 'package:flutter_app_getx/values/values.dart';

class SideNavBar extends StatefulWidget {

  final Function() close;
  final bool start;

  const SideNavBar({Key? key, required this.close, required this.start}) : super(key: key);

  @override
  _SideNavBarState createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {

  List<Widget> navItems = [
    TouchInk(
      onTap: () => Get.to(Home()),
      child: Tile(
        icon: Icons.home,
        text: 'Home',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(AlbumPage()),
      child: Tile(
        icon: Icons.photo_album,
        text: 'Plus',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(CropPage()),
      child: Tile(
        icon: Icons.crop,
        text: 'History',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(AboutPage()),
      child: Tile(
        icon: Icons.code_rounded,
        text: 'Code',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(BlogPage()),
      child: Tile(
        icon: Icons.wallet_giftcard_outlined,
        text: 'Wallet',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(ContactPage()),
      child: Tile(
        icon: Icons.favorite,
        text: 'Favorite',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(AlbumPage()),
      child: Tile(
        icon: Icons.question_answer,
        text: 'FAQ',
      ),
    ),
    TouchInk(
      onTap: () => Get.to(AlbumPage()),
      child: Tile(
        icon: Icons.phone,
        text: 'Support',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          color: Colors.yellow[800],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(icon: Icon(Icons.close_rounded), onPressed: widget.close),
              ColSpace(height: 30.0),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://picsum.photos/id/421/200/200'
                  ),
                ),
                title: Text('hello', style: textStyle.w300(14.0, Colors.black),),
                subtitle: Text('test', style: textStyle.w500(20.0, Colors.black),),
              ),
              ColSpace(height: 30.0),
              SingleChildScrollView(
                child: !widget.start
                    ? Column(
                  children: navItems,
                ) : AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            )
                        ),
                        children: navItems
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {

  final IconData icon;
  final String text;

  const Tile({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsets(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 22.0,),
          RowSpace(width: 10.0),
          Text(text, style: TextStyle(fontSize: 13.0),)
        ],
      ),
    );
  }
}