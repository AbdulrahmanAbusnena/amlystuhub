import 'package:flutter/material.dart';

// Small responsive helpers used across screens
class Breakpoints {
  static const double small = 700;
  static const double medium = 1000;
}

bool isSmallWidth(BoxConstraints constraints) => constraints.maxWidth < Breakpoints.small;
bool isMediumWidth(BoxConstraints constraints) => constraints.maxWidth >= Breakpoints.small && constraints.maxWidth < Breakpoints.medium;

// Useful utility to pick a value by breakpoint
T pickBySize<T>(BoxConstraints constraints, {required T small, required T large}) {
  return isSmallWidth(constraints) ? small : large;
}
