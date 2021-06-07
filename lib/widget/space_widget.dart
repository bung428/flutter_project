import 'package:flutter/material.dart';

class RowSpace extends StatelessWidget {

  final double width;

  const RowSpace({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class ColSpace extends StatelessWidget {

  final double height;

  const ColSpace({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}