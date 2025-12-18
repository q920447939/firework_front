import 'package:firework_front/widgets/container/container_wrapper_card.dart';
import 'package:firework_front/widgets/gap/gap_width.dart';
import 'package:firework_front/widgets/row_helper/row_helper.dart';
import 'package:firework_front/widgets/text/text_stype_grey_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// 购物车空页面
class CarEmptyPage extends StatefulWidget {
  const CarEmptyPage({super.key});

  @override
  State<CarEmptyPage> createState() => _CarEmptyPageState();
}

class _CarEmptyPageState extends State<CarEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 15.h, bottom: 10.h),
          child: Column(
            children: [
              rowMainAxisStart([
                gapWidthLarge(),
                TDText(
                  '购物车',
                  style: TextStyle(
                    fontSize: 22.sp,
                  ),
                ),
                gapWidthSmall(),
                Icon(
                  Icons.location_on_outlined,
                  size: 14.sp,
                ),
                GestureDetector(
                  onTap: () {
                    //AdressManagerIndexPageRouter().push(context);
                  },
                  child: TDText(
                    '请添加收货地址',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_right,
                  size: 16.sp,
                ),
              ]),
              SvgPicture.asset(
                'assets/base/svg/empty/empty_1.svg',
                width: 200.w,
                height: 250.w,
              ),
              TDText(
                '购物车空空如也,赶快加入喜欢的商品吧!',
                style: defaultWhiteTextStyleMini(),
              ),
              Gap(40.h),
              Center(
                child: SizedBox(
                  width: 320.w,
                  child: rowspaceBetween(
                    leftChild: GestureDetector(
                      onTap: () {
                        //MyFootPrintIndexPageRouter().push(context);
                      },
                      child: ContainerWrapperCard(
                        width: 150.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: TDText(
                            '查看足迹',
                            style: TextStyle(
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    rigthChild: GestureDetector(
                      onTap: () {
                        //SecKillGoodPageRouter().push(context);
                      },
                      child: ContainerWrapperCard(
                        width: 150.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: TDText(
                            '逛逛秒杀',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
