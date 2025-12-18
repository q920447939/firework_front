import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle defaultWhiteTextStylePrimary({
  fontSize = 16,
  fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    color: Colors.white,
    fontWeight: fontWeight,
  );
}

TextStyle defaultWhiteTextStyleXL({
  fontSize = 24,
  fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    color: Colors.white,
    fontWeight: fontWeight,
  );
}

TextStyle defaultWhiteTextStyleLarge({
  fontSize = 32,
  fontWeight = FontWeight.w500,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    color: Colors.white,
    fontWeight: fontWeight,
  );
}
