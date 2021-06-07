import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class textStyle {
  static TextStyle light(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w200);

  static TextStyle regular(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.normal);

  static TextStyle bold(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.bold);

  static TextStyle w300(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w300);

  static TextStyle w400(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w400);

  static TextStyle w500(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w500);

  static TextStyle w700(double size, Color color) => TextStyle(fontSize: size, color: color, fontWeight: FontWeight.w700);

  static TextStyle black300(double size)  => TextStyle(fontSize: size, color: Colors.black, fontWeight: FontWeight.w300);

  static TextStyle black400(double size)  => TextStyle(fontSize: size, color: Colors.black, fontWeight: FontWeight.w400);

  static TextStyle black500(double size)  => TextStyle(fontSize: size, color: Colors.black, fontWeight: FontWeight.w500);

  static TextStyle black700(double size)  => TextStyle(fontSize: size, color: Colors.black, fontWeight: FontWeight.w700);

  static TextStyle white300(double size)  => TextStyle(fontSize: size, color: Colors.white, fontWeight: FontWeight.w300);

  static TextStyle white400(double size)  => TextStyle(fontSize: size, color: Colors.white, fontWeight: FontWeight.w400);

  static TextStyle white500(double size)  => TextStyle(fontSize: size, color: Colors.white, fontWeight: FontWeight.w500);

  static TextStyle white700(double size)  => TextStyle(fontSize: size, color: Colors.white, fontWeight: FontWeight.w700);
}