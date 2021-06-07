double _unit = 1.0;
double _devicePixelRatio = 3.0;

set devicePixelRatio(double pixelRatio) => _devicePixelRatio = pixelRatio;

set dimenUnit(double unit) => _unit = unit;

double dimen(int value) {
  return value * _unit;
}

double get dimenInfinite => double.infinity;

int dimenToPx(double value) {
  return (value * _devicePixelRatio).toInt();
}

double pxToDimen(int px) {
  return px / _devicePixelRatio;
}

double pxToDimenFromString(String px, {double defaultValue = 0.0}) {
  try {
    return pxToDimen(int.parse(px));
  } on FormatException catch(_) {
  }
  return defaultValue;
}

double get unit => _unit;
