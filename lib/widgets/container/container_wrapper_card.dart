import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerWrapperCard extends StatelessWidget {
  double? width;
  double? height;
  Widget? child;
  BoxDecoration? decoration;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  Gradient? gradient;
  ContainerWrapperCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.decoration,
    this.margin,
    this.padding,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: decoration ??
          BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              gradient: gradient),
      child: child,
    );
  }
}

class LineGradientContainerWrapperCard extends StatelessWidget {
  double? width;
  double? height;
  Widget? child;
  BoxDecoration? decoration;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  List<Color> colors;
  final Alignment begin;
  final Alignment end;

  LineGradientContainerWrapperCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.decoration,
    this.margin,
    this.padding,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerWrapperCard(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      decoration: decoration,
      gradient: LinearGradient(colors: colors),
      child: child,
    );
  }
}
