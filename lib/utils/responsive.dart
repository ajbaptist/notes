// ignore_for_file: deprecated_member_use

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

MediaQueryData mediaQueryData = MediaQueryData.fromView(ui.window);
var height = mediaQueryData.size.height;
var width = mediaQueryData.size.width;

extension PercentSized on num {
  double get hp => (height * (this / 100));
  double get wp => (width * (this / 100));
}

extension ResponsiveText on num {
  double get sp => width / 100 * (this / 4.2);
  double get spp => height / 100 * (this / 4.2);
}
