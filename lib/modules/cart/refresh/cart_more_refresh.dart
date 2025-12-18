import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CartMoreRefresh<T> extends StatelessWidget {
  List<T> data;
  ScrollPhysics physics;
  Widget Function(dynamic item, int idx) childItem;
  CartMoreRefresh({
    super.key,
    required this.data,
    required this.childItem,
    required this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      physics: physics,
      itemBuilder: (_, index) {
        return childItem(data[index], index);
      },
    );
  }
}
