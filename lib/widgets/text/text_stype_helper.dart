import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle defaultTextStyle({
  fontSize = 16,
  color = Colors.white,
  fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    color: color,
    fontWeight: fontWeight,
  );
}
