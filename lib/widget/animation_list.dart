import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimationList extends StatelessWidget {

  AnimationList({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    TextStyle? style,
    this.listKey,
    this.animationType = AnimationType.slide,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  final AnimationType animationType;

  GlobalKey<AnimatedListState>? listKey;
  AnimatedListItemBuilder itemBuilder;
  List items;

  @override
  Widget build(BuildContext context) {
    final _list = items;
    final _builder = itemBuilder;

    return Expanded(
      flex: 1,
      child: AnimatedList(
          key: listKey,
          initialItemCount: _list.length,
          itemBuilder: _builder
      ),
    );
  }

}

enum AnimationType {
  slide,
  size,
  rotate,
  all,
}

extension AnimationTypeExt on AnimationType {
  static Widget from(AnimationType type, animation, child) {
    switch(type) {
      case AnimationType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      case AnimationType.size:
        return SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: child,
        );
      case AnimationType.rotate:
        return RotationTransition(
          turns: animation,
          child: child,
        );
      case AnimationType.all:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset(0, 0),
          ).animate(animation),
          child: RotationTransition(
            turns: animation,
            child: SizeTransition(
              axis: Axis.vertical,
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
      default:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        );
    }
  }
}