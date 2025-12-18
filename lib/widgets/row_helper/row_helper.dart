import 'package:flutter/cupertino.dart';

Row rowspaceBetween({
  required Widget leftChild,
  required Widget rigthChild,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      leftChild,
      rigthChild,
    ],
  );
}

Row rowspaceBetweenWithRightPadding({
  required Widget leftChild,
  required Widget rigthChild,
  double rightPadding = 5,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      leftChild,
      Padding(
        padding: EdgeInsets.only(
          right: rightPadding,
        ),
        child: rigthChild,
      ),
    ],
  );
}

Row rowMainAxisStart(
  List<Widget> childs, {
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: crossAxisAlignment,
    children: childs,
  );
}

Row rowMainAxisEnd(
  List<Widget> childs, {
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: crossAxisAlignment,
    children: childs,
  );
}

Row rowMainAxisCenter(
  List<Widget> childs, {
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: crossAxisAlignment,
    children: childs,
  );
}
