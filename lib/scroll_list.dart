import 'package:flutter/material.dart';
import 'package:flutter_app_getx/values/values.dart';

class ScrollList extends StatefulWidget {
  @override
  _ScrollListState createState() => _ScrollListState();
}

class _ScrollListState extends State<ScrollList> with TickerProviderStateMixin {

  late ScrollController _controller;
  var rate = 1.0;
  var old = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: NotificationListener<ScrollNotification> (
          onNotification: (notification) {
            var current = notification.metrics.pixels;
            var pixels = notification.metrics.pixels;
            var max = notification.metrics.maxScrollExtent;
            var min = notification.metrics.minScrollExtent;

            setState(() {
              if (current > 10) {
                rate = (current - old).abs();
                old = current;
              }
              if (pixels >= max - 50) {
                rate = 0.0;
              }
              if (pixels <= min + 50) {
                rate = 0.0;
              }
            });

            return true;
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AnimatedPadding(
                      padding: edgeInsets(
                        start: 10.0,
                        end: 10.0,
                        top: (rate + 10).abs() > 80 ? 80 : (rate + 10).abs()
                      ),
                      duration: Duration(milliseconds: 375),
                      curve: Curves.easeOut,
                      child: Container(
                        height: 100.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                      ),
                    );
                  }
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
