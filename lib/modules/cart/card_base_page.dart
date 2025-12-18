import 'package:firework_front/core/widget/custom_safe_area/CustomSafeArea.dart';
import 'package:firework_front/modules/cart/car_empty_page.dart';
import 'package:firework_front/modules/cart/refresh/cart_more_refresh.dart';
import 'package:firework_front/widgets/container/container_wrapper_card.dart';
import 'package:firework_front/widgets/easy_refresh/easy_refresh_wrapper.dart';
import 'package:firework_front/widgets/gap/gap_height.dart';
import 'package:firework_front/widgets/gap/gap_width.dart';
import 'package:firework_front/widgets/row_helper/row_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class CardBasePage extends StatefulWidget {
  const CardBasePage({super.key});

  @override
  State<CardBasePage> createState() => _CardBasePageState();
}

class _CardBasePageState extends State<CardBasePage> {
  final int _DEFAULT_PAGE_NO = 1;
  late int pageNo = _DEFAULT_PAGE_NO;

  int size = 10;
  List<dynamic> uploadList = [];

  bool _isShowEmpty = false;

  Future<List<dynamic>> init() async {
    pageNo = _DEFAULT_PAGE_NO;
    /*uploadList = await BabyDao.more(
            pageNo, size, widget.queryCollect, widget.isCollect) ??
        [];*/
    uploadList = List.generate(10, (idx) => idx).toList();
    //_isShowEmpty = true;
    return uploadList;
  }

  Future<List<dynamic>> more(int pageNo, int babyId) async {
    /*uploadList = await BabyDao.more(
            pageNo, size, widget.queryCollect, widget.isCollect) ??
        [];*/
    uploadList = List.generate(10, (idx) => idx).toList();

    return uploadList;
  }

  @override
  Widget build(BuildContext context) {
    if (_isShowEmpty) {
      return CarEmptyPage();
    }
    return CustomerSafeArea(
      child: Container(
        color: Color(0xFFF5F4F9),
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildHead(),
                gapHeightNormal(),
                SizedBox(height: 700.h, child: _buildBody()),
              ],
            ),
            buildFixBottom(),
          ],
        ),
      ),
    );
  }

  Positioned buildFixBottom() {
    return Positioned(
      bottom: 1.h,
      left: 0,
      right:
          0, //添加 right: 0 来确保 Positioned 组件横向撑满父容器 ,(Positioned 组件需要明确的宽度才能正确定位其子组件)
      child: ContainerWrapperCard(
        height: 50.h,
        child: rowspaceBetweenWithRightPadding(
          leftChild: rowMainAxisStart([
            SvgPicture.asset(
              'assets/svg/tick_new.svg',
              width: 18,
              height: 18,
              color: Colors.green,
            ),
            gapWidthSmall(),
            TDText('全选', style: TextStyle(fontSize: 14.sp)),
            gapWidthNormal(),
            Baseline(
              baseline: 22,
              baselineType: TextBaseline.alphabetic,
              child: TDText(
                '¥',
                style: TextStyle(
                  color: Color(0xFFF60541),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Baseline(
              baseline: 28,
              baselineType: TextBaseline.alphabetic,
              child: TDText(
                '1000',
                style: TextStyle(
                  color: Color(0xFFF60541),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
          rigthChild: Container(
            width: 120.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFF2442),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10.r),
                right: Radius.circular(10.r),
              ),
            ),
            child: Center(
              child: TDText(
                '立即购买',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildHead() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.fromLTRB(5, 5, 2, 5),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: rowspaceBetweenWithRightPadding(
        leftChild: TDText(
          '购物车',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        rigthChild: GestureDetector(
          onTap: () {},
          child: TDText('编辑', style: TextStyle(fontSize: 14.sp)),
        ),
      ),
    );
  }

  _buildBody() {
    return ContainerWrapperCard(
      child: EasyRefreshWrapper<dynamic>(
        initLoad: (int pageNo, int pageSize) async {
          return init();
        },
        loadMore: (int pageNo, int pageSize) {
          return more(++pageNo, 1);
        },
        listBuilder: (List<dynamic> list, ScrollPhysics physics) {
          return CartMoreRefresh<dynamic>(
            data: list,
            childItem: _buildItem,
            physics: physics,
          );
        },
      ),
    );
  }

  Widget _buildItem(item, index) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowspaceBetweenWithRightPadding(
            leftChild: rowMainAxisStart([
              SvgPicture.asset(
                'assets/svg/tick_new.svg',
                width: 18,
                height: 18,
                color: Colors.green,
              ),
              gapWidthTiny(),
              TDImage(
                assetUrl: 'assets/img/image.png',
                width: 150,
                height: 100,
              ),
            ]),
            rigthChild: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 215.w,
                  child: TDText(
                    'Apple/苹果iPhone 16 Pro Max（A3297）256GB 白色钛金属支持移动联通电信5G 双卡双待手机.',
                    maxLines: 2,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
                gapHeightSmall(),
                ContainerWrapperCard(
                  width: 215.w,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  ),
                  child: rowspaceBetweenWithRightPadding(
                    leftChild: Center(
                      child: TDText(
                        '13.5+0.05克 58号',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    rigthChild: Icon(Icons.keyboard_arrow_down, weight: 0.8),
                  ),
                ),
                gapHeightSmall(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Baseline(
                          baseline: 28,
                          baselineType: TextBaseline.alphabetic,
                          child: TDText(
                            '¥',
                            style: TextStyle(
                              color: Color(0xFFF60541),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Baseline(
                          baseline: 28,
                          baselineType: TextBaseline.alphabetic,
                          child: TDText(
                            '1000',
                            style: TextStyle(
                              color: Color(0xFFF60541),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(70.w),
                    TDStepper(
                      theme: TDStepperTheme.filled,
                      value: 999,
                      max: 999,
                    ),
                  ],
                ),
              ],
            ),
          ),
          gapHeightTiny(),
          TDDivider(),
        ],
      ),
    );
  }
}
