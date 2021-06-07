import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class BaseProvider<T extends BaseController> extends StatelessWidget {

  final Color? backgroundColor;
  final Color? bodyColor;
  final bool? resizeToAvoidBottomInset;

  const BaseProvider({this.backgroundColor, this.bodyColor, this.resizeToAvoidBottomInset, Key? key}) : super(key: key);

  final String? tag = null;
  T get controller => GetInstance().find<T>(tag: tag);

  PreferredSizeWidget? appBar();

  Widget body(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: backgroundColor ?? Colors.white,
          appBar: appBar(),
          body: bodyColor != null
            ? Container(
                color: bodyColor,
                child: body(context)
              )
            : body(context),
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        );
      },
    );
  }
}