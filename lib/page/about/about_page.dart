import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/space_widget.dart';
import '../../values/values.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff101010),
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _controller,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColSpace(height: 40),
                    Text('Get to know me', style: textStyle.w400(15.0, Colors.white70),),
                    ColSpace(height: 8),
                    Text('About Me', style: textStyle.white700(46.0),),
                    ColSpace(height: 40),
                    Container(
                      height: 600,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            child: Get.width < 992
                              ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://picsum.photos/id/421/200/200'
                              ),
                              radius: 30.0,
                            ) : Container(
                              height: 500,
                              child: Image(
                                image: NetworkImage(
                                  'https://picsum.photos/id/421/200/200'
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: 570,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Get.width > 992
                                  ? Container()
                                  : ColSpace(height: 35),
                                Text('Who am i?', style: textStyle.w500(25, Color(0xff009e66)),),
                                ColSpace(height: 6),
                                FittedBox(
                                  child: Text('blah blah blah blah blah blah blah blah blah blah', style: textStyle.white500(33), maxLines: 2,),
                                ),
                                ColSpace(height: 15),
                                Text('blah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blahblah blah blah blah blah blah blah blah blah blah', style: textStyle.w400(16, Colors.white70), maxLines: 5,),
                                ColSpace(height: 25),
                                Container(
                                  width: double.maxFinite,
                                  height: 2.0,
                                  color: Colors.white70,
                                ),
                                Padding(
                                  padding: edgeInsets(top: 10.0),
                                  child: Get.width > 800
                                      ? Row(
                                    children: [
                                      Cvcard(text1: 'Name : ', text2: 'Blah blah'),
                                      Spacer(),
                                      Cvcard(text1: 'Mail : ', text2: 'bgk@storecamera.io'),
                                    ],
                                  )  : Column(
                                    children: [
                                      Cvcard(text1: 'Name : ', text2: 'Blah blah'),
                                      Spacer(),
                                      Cvcard(text1: 'Mail : ', text2: 'bgk@storecamera.io'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: edgeInsets(top: 10.0),
                                  child: Get.width > 800
                                      ? Row(
                                    children: [
                                      Cvcard(text1: 'Age : ', text2: '30'),
                                      Spacer(),
                                      Cvcard(text1: 'From : ', text2: 'jamsil'),
                                    ],
                                  )  : Column(
                                    children: [
                                      Cvcard(text1: 'Age : ', text2: '30'),
                                      Spacer(),
                                      Cvcard(text1: 'From : ', text2: 'jamsil'),
                                    ],
                                  ),
                                ),
                                ColSpace(height: 35),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50.0),
                                        color: Color(0xff009e66)
                                      ),
                                      child: Center(
                                        child: Text('Download CV', style: textStyle.white400(16),)
                                      ),
                                    ),
                                    Get.width > 670
                                        ? Container(
                                      color: Colors.white70,
                                      width: 100,
                                      height: 1.0,
                                      margin: edgeInsets(start: 7.0, end: 10.0),
                                    )   : Container(),
                                     Row(
                                       children: [
                                         // Icon(AntDes)
                                       ],
                                     )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColSpace(height: 40),
                          Text('  Services i offer to my clients.', style: textStyle.w400(15, Colors.white70),),
                          ColSpace(height: 8),
                          Text(' My Services', style: textStyle.white700(46),),
                          ColSpace(height: 25),
                        ],
                      ),
                    ),
                    Container(
                      height: 300,
                      child: Wrap(
                        children: [
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                          ServiceCard(icon: IconData(0), head: 'Trends', sub: 'test test test test test test test'),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColSpace(height: 40),
                          Text(
                            ' Get Started with my services',
                            style: textStyle.w400(15, Colors.white70),
                          ),
                          ColSpace(height: 8),
                          Text(
                            ' Choose a Plan', style: textStyle.white700(46),
                          ),
                          ColSpace(height: 25)
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: Get.width < 700 ? Get.width * 0.6 : Get.width * 0.9,
                        height: 500,
                        child: Wrap(
                          children: [
                            PlanCard(icon: IconData(1), btext: 'Get Started'),
                            PlanCard(icon: IconData(1), btext: 'Get Started'),
                            PlanCard(icon: IconData(1), btext: 'Get Started'),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class PlanCard extends StatefulWidget {

  final IconData icon;
  final String btext;

  const PlanCard({Key? key, required this.icon, required this.btext}) : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: edgeInsets(bottom: 50),
      height: 550,
      color: Color(0xff161616),
      child: Column(
        children: [
          Icon(widget.icon, color: Color(0xff009e66), size: 75,),
          ColSpace(height: 40),
          Text('Test Test Test', style: textStyle.w300(18, Colors.white70),),
          ColSpace(height: 15),
          Text('Test Test Test', style: textStyle.w300(18, Colors.white70),),
          ColSpace(height: 15),
          Text('Test Test Test', style: textStyle.w300(18, Colors.white70),),
          ColSpace(height: 30),
          Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xff009e66),
            ),
            child: Center(
              child: Text(
                widget.btext,
                style: textStyle.white300(16),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ServiceCard extends StatefulWidget {

  final IconData icon;
  final String head;
  final String sub;

  const ServiceCard({Key? key, required this.icon, required this.head, required this.sub}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          hover = true;
        });
      },
      onExit: (value) {
        setState(() {
          hover = false;
        });
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(-1, 1),
                  blurRadius: 5.0,
                  spreadRadius: 0.5
                )
              ],
              color: Color(0xff161616)
            ),
            margin: edgeInsets(bottom: 50.0),
            height: 230,
            child: Column(
              children: [
                Padding(
                  padding: edgeInsets(horizontal: 35, top: 20, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 50,),
                      ColSpace(height: 15),
                      Text(widget.head, style: textStyle.white500(21.0),),
                      ColSpace(height: 8),
                      Text(widget.sub, style: textStyle.w300(16, Colors.white70),),

                    ],
                  ),
                ),
                Spacer(),
                AnimatedContainer(
                  duration:  Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 2.0,
                  color: !hover ? Color(0xff161616) : Color(0xff009e66),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


class Cvcard extends StatefulWidget {

  final String text1;
  final String text2;

  const Cvcard({Key? key, required this.text1, required this.text2}) : super(key: key);

  @override
  _CvcardState createState() => _CvcardState();
}

class _CvcardState extends State<Cvcard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(widget.text1, style: textStyle.white400(16),),
          Text(widget.text2, style: textStyle.w400(16, Color(0xff009e66)),),
        ],
      ),
    );
  }
}

