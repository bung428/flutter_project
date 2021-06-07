import 'package:flutter/material.dart';
import 'package:flutter_scrollbar/webscrollbar.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff101010),
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 43.0,),
                    Text(
                      'Check out my latest blog posts',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.0,),
                    Text(
                      'My Blog',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 112.0,),
                    Center(
                      child: Container(
                        width: Get.width > 1300
                            ? Get.width * 0.65
                            : Get.width > 1200
                              ? Get.width * 0.75
                              : Get.width * 0.85,
                        child:
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: ResponsiveGridDelegate(
                            maxCrossAxisExtent: 370.0,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: 40,
                          itemBuilder: (context, index) {
                            return BlogCard(
                                image: '',
                                head: 'Take a tourof my office',
                                sub: 'Lorem ipsum dolor sit await, Lorem ipsum dolor sit await, Lorem ipsum dolor sit await, Lorem ipsum dolor sit await'
                            );
                          },
                        )
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

class BlogCard extends StatefulWidget {
  final String? head;
  final String? sub;
  final String? image;
  BlogCard({this.head, this.sub, this.image});
  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 400,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white70,
              image: DecorationImage(
                image: NetworkImage(widget.image ?? ''),
                fit: BoxFit.cover,
              ),
            ),
            height: 231,
            width: 370,
          ),
          SizedBox(height: 15.0,),
          Container(
            child: Text(
              widget.head ?? '',
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20.0
              ),
            ),
          ),
          SizedBox(height: 8.0,),
          FittedBox(
            fit: BoxFit.cover,
            child: Container(
              width: 370,
              child: Text(
                widget.sub ?? '',
                maxLines: 3,
                style: TextStyle(
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  fontSize: 14.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
