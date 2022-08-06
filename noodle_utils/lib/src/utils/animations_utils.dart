import 'dart:math';

double linearMap({
  required double source,
  double sourceMin = 0,
  double sourceMax = 100,
  required double targetMin,
  required double targetMax,
}) {
  return ((source - sourceMin) / (sourceMax - sourceMin)) *
          (targetMax - targetMin) +
      targetMin;
}

double linearMapSafe({
  required double source,
  double sourceMin = 0,
  double sourceMax = 100,
  required double targetMin,
  required double targetMax,
}) {
  final value = ((source - sourceMin) / (sourceMax - sourceMin)) *
          (targetMax - targetMin) +
      targetMin;

  if (value > targetMax) {
    return targetMax;
  }

  if (value < targetMin) {
    return targetMin;
  }

  return value;
}

double clampedLinearPercent(
    double percent, double expandAnchor, double collapseAnchor) {
  return ((max(percent, collapseAnchor) - collapseAnchor) /
          (expandAnchor - collapseAnchor)) *
      expandAnchor;
}

/*
 * Returns a value in a specific renge, 
 * case source is greather then maxValue, or smaller than minValue 
 * the value returned is the limit
 * @param source - value 
 * @param minValue - min value of range
 * @param maxValue -  max value of range 
 */
double clamp(
    {required double source, double minValue = 0, double maxValue = 1}) {
  return min(maxValue, max(minValue, source));
}
