import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResponsiveRow extends StatelessWidget {

  final double? height;
  List<Widget> children;

  ResponsiveRow({Key? key, required this.children, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: height ?? 0,
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: children,
          ),
        );
      }
    );
  }
}