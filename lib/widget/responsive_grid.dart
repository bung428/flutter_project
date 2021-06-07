import 'package:flutter/material.dart';

class ResponsiveGrid extends StatefulWidget {

  final Widget? child;
  final double childWidth;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  const ResponsiveGrid({Key? key, required this.childWidth, this.child, this.mainAxisSpacing, this.crossAxisSpacing}) : super(key: key);

  @override
  _ResponsiveGridState createState() => _ResponsiveGridState();
}

class _ResponsiveGridState extends State<ResponsiveGrid> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this,);
    _animation = CurvedAnimation( parent: _controller, curve: Curves.easeIn, );
    _animation.addListener(() { setState(() { }); });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var _width = widget.childWidth + _animation.value * 15;
          var _maxCount = constraints.maxWidth ~/ _width;
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _maxCount,
                    crossAxisSpacing: widget.crossAxisSpacing ?? 12.0,
                    mainAxisSpacing: widget.mainAxisSpacing ?? 12.0,
                  ),
                  itemBuilder: (context, index) {
                    final _child = widget.child;
                    return _child != null ? _child : Container();
                    // return Container(color: Colors.teal, width: _width, height: _width, child: Text('hi'),);
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
