import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:responsive_framework/responsive_grid.dart';

class ResumePage extends StatefulWidget {
  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    print("KBG Get.width : ${Get.width}");
    return Scaffold(
      backgroundColor: Color(0xff101010),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _controller,
              child: Center(
                child: Column(
                  children: [
                    TextButton(onPressed: () {
                      print("KBG test 2 ${Get.width}");
                    }, child: Text('button')),
                    SizedBox(height: 43.0,),
                    Text(
                      'Check out my Resume',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      'Resume',
                      style: TextStyle(
                        fontSize: 46.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 112.0,),
                    Get.width > 950
                      ? Row(
                          children: [
                            ResumeCard(head: 'Education'),
                            SizedBox(width: 75.0,),
                            ResumeCard(head: 'Experience')
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ResumeCard(head: 'Education'),
                            SizedBox(width: 75.0,),
                            ResumeCard(head: 'Experience')
                          ],
                        ),
                    SizedBox(height: 120.0,),
                    Container(
                      width: Get.width * 0.7 + 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Text(
                                  'My level if knowledge!!@#!@#!@#!#',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                                SizedBox(height: 8.0,),
                                Text(
                                  'My Skills',
                                  style: TextStyle(
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white
                                  ),
                                ),
                                Get.width > 950
                                 ? Row(
                                  children: [
                                    PercentItem(),
                                    SizedBox(width: 50.0,),
                                    PercentItem(),
                                  ],
                                )
                                  : Column(
                                  children: [
                                    PercentItem(),
                                    SizedBox(width: 50.0,),
                                    PercentItem(),
                                  ],
                                ),
                                SizedBox(height: 100.0,),
                                Container(
                                  width: Get.width * 0.7 + 70,
                                  child: ResponsiveGridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: ResponsiveGridDelegate(
                                      childAspectRatio: 3 / 2,
                                      maxCrossAxisExtent: 460.0,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemCount: 3,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        width: 460,
                                        height: 370,
                                        color: index == 0 ? Colors.teal : Colors.amber,
                                      );
                                    },
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResumeCard extends StatefulWidget {

  final String head;

  const ResumeCard({Key? key, required this.head}) : super(key: key);

  @override
  _ResumeCardState createState() => _ResumeCardState();
}

class _ResumeCardState extends State<ResumeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.head,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
          SizedBox(height: 15.0,),
          CustomCard(
            head: 'Custom Card Head',
            sub: 'Custom Card Sub First',
            sub2: 'Custom Card Sub Second'
          ),
          Container(
            height: 1.5,
            width: Get.width > 950 ? Get.width * 0.35 : Get.width * 0.7,
            color: Colors.white,
          ),
          CustomCard(
              head: 'Computer Science',
              sub: 'Lorem ipsum dolor si amet, consctetur!!!!',
              sub2: 'Cambridge University'
          ),
          Container(
            height: 1.5,
            width: Get.width > 950 ? Get.width * 0.35 : Get.width * 0.7,
            color: Colors.white,
          ),
          CustomCard(
              head: 'Computer Science',
              sub: 'Lorem ipsum dolor si amet, consctetur!!!!',
              sub2: 'Cambridge University'
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatefulWidget {

  final String head;
  final String sub;
  final String sub2;

  const CustomCard({Key? key, required this.head, required this.sub, required this.sub2}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      width: Get.width > 950 ? Get.width * 0.35 : Get.width * 0.7,
      color: Color(0xff161616),
      child: Row(
        children: [
          Container(
            width: 50,
            child: Stack(
              children: [
                Container(
                  height: 250.0,
                  width: 2,
                  color: Color(0xff009e66),
                ),
                Positioned(
                    top: 50.0,
                    left: 1,
                    child: Container(
                      height: 20.0,
                      width: 25.0,
                      color: Color(0xff009e66),
                    )
                ),
                Positioned(
                    top: 53.0,
                    left: 10.5,
                    child: Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Container(
                        height: 14.0,
                        width: 14.0,
                        color: Color(0xff009e66),
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            width: Get.width > 950 ? Get.width * 0.35 - 60 : Get.width * 0.7 - 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45,),
                Text(
                  widget.head,
                  style: TextStyle(
                    fontSize: 21.0,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  widget.sub,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  widget.sub2,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PercentItem extends StatefulWidget {
  @override
  _PercentItemState createState() => _PercentItemState();
}

class _PercentItemState extends State<PercentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PercentCard(
            progress: 0.95,
            text: 'HTML/CSS'
          ),
          PercentCard(
              progress: 0.8,
              text: 'Web Design'
          ),
          PercentCard(
              progress: 0.9,
              text: 'JavaScript'
          ),
        ],
      ),
    );
  }
}

class PercentCard extends StatefulWidget {

  final double progress;
  final String text;

  const PercentCard({Key? key, required this.progress, required this.text}) : super(key: key);

  @override
  _PercentCardState createState() => _PercentCardState();
}

class _PercentCardState extends State<PercentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width > 950 ? Get.width * 0.3 + 35 : Get.width * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 45.0,),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 10.0,),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: widget.progress,
            backgroundColor: Color(0xff161616),
            progressColor: Color(0xff009e66),
            animation: true,
            animationDuration: 1000,
            linearStrokeCap: LinearStrokeCap.butt,
          ),
        ],
      ),
    );
  }
}
