class CropGestureData {
  final double layoutWidth;
  final double layoutHeight;
  final double viewWidth;
  final double viewHeight;
  final int imageWidth;
  final int imageHeight;

  final double dx;
  final double dy;
  final double scale;

  CropGestureData(this.layoutWidth, this.layoutHeight, this.viewWidth, this.viewHeight, this.imageWidth, this.imageHeight, this.dx, this.dy, this.scale);

  double get viewLeft => (layoutWidth - viewWidth) / 2;

  double get viewTop => (layoutHeight - viewHeight) / 2;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CropGestureData &&
              runtimeType == other.runtimeType &&
              layoutWidth == other.layoutWidth &&
              layoutHeight == other.layoutHeight &&
              viewWidth == other.viewWidth &&
              viewHeight == other.viewHeight &&
              imageWidth == other.imageWidth &&
              imageHeight == other.imageHeight &&
              dx == other.dx &&
              dy == other.dy &&
              scale == other.scale;

  @override
  int get hashCode =>
      layoutWidth.hashCode ^
      layoutHeight.hashCode ^
      viewWidth.hashCode ^
      viewHeight.hashCode ^
      imageWidth.hashCode ^
      imageHeight.hashCode ^
      dx.hashCode ^
      dy.hashCode ^
      scale.hashCode;
}