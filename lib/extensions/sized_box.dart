import 'package:flutter/material.dart';

const Widget sizedHeight2 = SizedBox(height: 2);

extension SpacedXY on double {
  SizedBox get spaceX => SizedBox(width: this);
  SizedBox get spaceY => SizedBox(height: this);
}

extension SpaceiXY on int {
  SizedBox get spaceX => SizedBox(width: toDouble());
  SizedBox get spaceY => SizedBox(height: toDouble());
}
