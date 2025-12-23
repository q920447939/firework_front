import 'package:firework_front/modules/cart/car_empty_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CardBasePage extends StatefulWidget {
  const CardBasePage({super.key});

  @override
  State<CardBasePage> createState() => _CardBasePageState();
}

class _CardBasePageState extends State<CardBasePage> {
  static const Color _bg = Color(0xFFF5F4F9);
  static const Color _brandRed = Color(0xFFDF1F2D);
  static const Color _textMain = Color(0xFF1A1A1A);
  static const Color _textSub = Color(0xFF8C8C8C);
  static const Color _divider = Color(0xFFEFEFEF);

  static const double _bottomBarHeight = 122;

  late final List<_CartItemVm> _items = <_CartItemVm>[
    _CartItemVm(
      name: '金龙牌 组合烟花',
      spec: '规格:36支/盒',
      priceYuan: 268,
      originalYuan: 388,
      quantity: 2,
      selected: true,
    ),
    _CartItemVm(
      name: '彩虹喷泉烟花礼盒',
      spec: '规格:12支/盒',
      priceYuan: 158,
      originalYuan: 229,
      quantity: 1,
      selected: true,
    ),
    _CartItemVm(
      name: '星光闪耀手持烟花',
      spec: '规格:50克/包',
      priceYuan: 88,
      originalYuan: 113,
      quantity: 3,
      selected: false,
    ),
  ];

  late final List<_RecommendItemVm> _recommendations = <_RecommendItemVm>[
    _RecommendItemVm(name: '星空瀑布喷泉', priceYuan: 98),
    _RecommendItemVm(name: '金色满天星', priceYuan: 128),
    _RecommendItemVm(name: '好运仙女棒', priceYuan: 36),
    _RecommendItemVm(name: '节日礼炮', priceYuan: 168),
  ];

  bool get _hasAnySelected => _items.any((e) => e.selected);
  bool get _isAllSelected =>
      _items.isNotEmpty && _items.every((e) => e.selected);
  int get _selectedLineCount => _items.where((e) => e.selected).length;
  int get _selectedTotalYuan => _items
      .where((e) => e.selected)
      .fold<int>(0, (sum, e) => sum + e.priceYuan * e.quantity);

  void _toggleSelectAll() {
    final next = !_isAllSelected;
    setState(() {
      for (final item in _items) {
        item.selected = next;
      }
    });
  }

  void _toggleItemSelected(int index) {
    setState(() {
      _items[index].selected = !_items[index].selected;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _changeQty(int index, int delta) {
    setState(() {
      final next = (_items[index].quantity + delta).clamp(1, 999);
      _items[index].quantity = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const CarEmptyPage();

    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            children: [
              _buildStoreCard(),
              Gap(12.h),
              for (var i = 0; i < _items.length; i++) ...[
                _buildCartItemCard(_items[i], index: i),
                Gap(8.h),
              ],
              //_buildRecommendHeader(),
              //Gap(10.h),
              //Spacer(),
              //_buildRecommendGrid(),
              //Gap(20.h),
            ],
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 44.h,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: Colors.white),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
            return;
          }
          context.go('/');
        },
      ),
      title: Text(
        '购物车',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      /* actions: [
        IconButton(
          icon: Icon(Icons.more_vert, size: 20.sp, color: Colors.white),
          onPressed: () {
            if (kDebugMode) {
              debugPrint('cart: more');
            }
          },
        ),
      ], */
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD41C25), Color(0xFFDF1F2D)],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: _brandRed,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.storefront, color: Colors.white, size: 18.sp),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '蛙蛙烟花旗舰店',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: _textMain,
                  ),
                ),
                Gap(2.h),
                Text(
                  '官方直营 正品保障',
                  style: TextStyle(fontSize: 11.sp, color: _textSub),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: const Color(0xFFBDBDBD),
            size: 22.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(_CartItemVm item, {required int index}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _toggleItemSelected(index),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h, right: 10.w),
                    child: _SquareCheck(checked: item.selected),
                  ),
                ),
                _buildThumb(),
                Gap(10.w),
                Expanded(child: _buildItemInfo(item)),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: _divider),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _removeItem(index),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 6.w,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20.sp,
                      color: const Color(0xFFB5B5B5),
                    ),
                  ),
                ),
                const Spacer(),
                _QtyStepper(
                  value: item.quantity,
                  onMinus: () => _changeQty(index, -1),
                  onPlus: () => _changeQty(index, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumb() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 98.w,
        height: 62.h,
        color: const Color(0xFF111111),
        child: Center(
          child: Image.asset(
            'assets/svg/logo.png',
            width: 46.w,
            height: 46.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildItemInfo(_CartItemVm item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.2,
            color: _textMain,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(6.h),
        Text(
          item.spec,
          style: TextStyle(fontSize: 11.sp, color: _textSub),
        ),
        Gap(8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '¥${item.priceYuan}',
              style: TextStyle(
                fontSize: 16.sp,
                color: _brandRed,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(8.w),
            Text(
              '¥${item.originalYuan}',
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFFB0B0B0),
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: _brandRed, size: 18.sp),
          Gap(6.w),
          Text(
            '为你推荐',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: _textMain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendGrid() {
    return GridView.builder(
      itemCount: _recommendations.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final item = _recommendations[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFF111111),
                      child: Center(
                        child: Image.asset(
                          'assets/svg/logo.png',
                          width: 46.w,
                          height: 46.w,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(8.h),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _textMain,
                  ),
                ),
                Gap(4.h),
                Text(
                  '¥${item.priceYuan}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _brandRed,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: _bottomBarHeight.h,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleSelectAll,
                child: Row(
                  children: [
                    _SquareCheck(checked: _isAllSelected),
                    Gap(8.w),
                    Text(
                      '全选',
                      style: TextStyle(fontSize: 13.sp, color: _textMain),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '合计',
                    style: TextStyle(fontSize: 11.sp, color: _textSub),
                  ),
                  Text(
                    '¥$_selectedTotalYuan',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: _brandRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(10.h),
          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.r),
                ),
                elevation: 0,
              ),
              onPressed: _hasAnySelected ? () {} : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department_outlined, size: 18.sp),
                  Gap(6.w),
                  Text(
                    '提交订单（$_selectedLineCount）',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemVm {
  _CartItemVm({
    required this.name,
    required this.spec,
    required this.priceYuan,
    required this.originalYuan,
    required this.quantity,
    required this.selected,
  });

  final String name;
  final String spec;
  final int priceYuan;
  final int originalYuan;
  int quantity;
  bool selected;
}

class _RecommendItemVm {
  _RecommendItemVm({required this.name, required this.priceYuan});
  final String name;
  final int priceYuan;
}

class _SquareCheck extends StatelessWidget {
  const _SquareCheck({required this.checked});
  final bool checked;

  @override
  Widget build(BuildContext context) {
    final borderColor = checked
        ? const Color(0xFF6B6B6B)
        : const Color(0xFFBDBDBD);
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: checked
          ? Icon(Icons.check, size: 14.sp, color: borderColor)
          : const SizedBox.shrink(),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperCircle(icon: Icons.remove, onTap: onMinus),
        SizedBox(
          width: 34.w,
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: _CardBasePageState._textMain,
              ),
            ),
          ),
        ),
        _StepperCircle(icon: Icons.add, onTap: onPlus),
      ],
    );
  }
}

class _StepperCircle extends StatelessWidget {
  const _StepperCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Icon(icon, size: 16.sp, color: const Color(0xFF8D8D8D)),
      ),
    );
  }
}
