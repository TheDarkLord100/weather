import 'package:flutter/material.dart';

extension CustomExtensions on Widget {
  Padding paddingForAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Padding paddingWithSymmetry(
          {double vertical = 0.0, double horizontal = 0.0}) =>
      Padding(
        padding:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        child: this,
      );

  Padding paddingLTRB(double left, double top, double right, double bottom) =>
      Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: this,
      );

  Padding paddingForOnly(
          {double left = 0.0,
          double right = 0.0,
          double top = 0.0,
          double bottom = 0.0}) =>
      Padding(
        padding:
            EdgeInsets.only(left: left, right: right, bottom: bottom, top: top),
        child: this,
      );

  Center wrapCenter() => Center(child: this,);
}
