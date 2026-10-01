import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  // Uses Flutter's modern, safe size lookup
  double resHeight(double percentage) => MediaQuery.sizeOf(this).height * percentage;
  double resWidth(double percentage) => MediaQuery.sizeOf(this).width * percentage;
}