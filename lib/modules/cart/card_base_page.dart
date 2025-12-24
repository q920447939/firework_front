import 'dart:async';

import 'package:firework_front/core/models/cart_item_model.dart';
import 'package:firework_front/core/widget/custom_network_image.dart';
import 'package:firework_front/modules/cart/car_empty_page.dart';
import 'package:firework_front/modules/cart1/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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

  late final CartController _cartController;
  final Set<String> _selectedIds = <String>{};
  bool _selectionInitialized = false;

  @override
  void initState() {
    super.initState();
    _cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_cartController.loadCart().then((_) => _cartController.refreshLatestPrices()));
    });
  }

  void _initSelectionIfNeeded(List<CartItem> items) {
    if (_selectionInitialized) {
      final existingIds = items.map((e) => e.id).toSet();
      _selectedIds.removeWhere((id) => !existingIds.contains(id));
      return;
    }
    _selectionInitialized = true;
    _selectedIds
      ..clear()
      ..addAll(items.map((e) => e.id));
  }

  bool _isSelected(CartItem item) => _selectedIds.contains(item.id);

  void _toggleSelectAll(List<CartItem> items) {
    final isAllSelected = items.isNotEmpty && items.every(_isSelected);
    setState(() {
      if (isAllSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(items.map((e) => e.id));
      }
    });
  }

  void _toggleItemSelected(CartItem item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else {
        _selectedIds.add(item.id);
      }
    });
  }

  Future<void> _confirmRemoveItem(CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          title: Text(
            '确认删除？',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          content: Text(
            '确认删除“${item.name}”吗？',
            style: TextStyle(fontSize: 13.sp, color: _textSub),
          ),
          actionsPadding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                '取消',
                style: TextStyle(color: _textSub, fontSize: 13.sp),
              ),
            ),
            SizedBox(width: 6.w),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                '删除',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    setState(() => _selectedIds.remove(item.id));
    await _cartController.removeItem(item.id);
  }

  void _changeQty(CartItem item, int delta) {
    final next = item.quantity + delta;
    if (next < 1) return;
    unawaited(_cartController.updateQuantity(item.id, delta));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = _cartController.cartItems;
      if (items.isEmpty) return const CarEmptyPage();
      _initSelectionIfNeeded(items);

      final isAllSelected = items.isNotEmpty && items.every(_isSelected);
      final selectedItems = items.where(_isSelected).toList();
      final hasAnySelected = selectedItems.isNotEmpty;
      final selectedLineCount = selectedItems.length;
      final selectedTotal = selectedItems.fold<double>(
        0,
        (sum, e) => sum + e.price * e.quantity,
      );

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
                for (final item in items) ...[
                  _buildCartItemCard(item),
                  Gap(8.h),
                ],
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomBar(
                isAllSelected: isAllSelected,
                selectedTotal: selectedTotal,
                selectedLineCount: selectedLineCount,
                hasAnySelected: hasAnySelected,
                onToggleSelectAll: () => _toggleSelectAll(items),
              ),
            ),
          ],
        ),
      );
    });
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
            decoration: const BoxDecoration(color: _brandRed, shape: BoxShape.circle),
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
          Icon(Icons.chevron_right, color: const Color(0xFFBDBDBD), size: 22.sp),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    final checked = _isSelected(item);
    final showOriginal = item.originalPrice > item.price;

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
                  onTap: () => _toggleItemSelected(item),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h, right: 10.w),
                    child: _SquareCheck(checked: checked),
                  ),
                ),
                _buildThumb(item.imageUrl),
                Gap(10.w),
                Expanded(
                  child: _buildItemInfo(
                    item,
                    showOriginal: showOriginal,
                  ),
                ),
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
                  onTap: () => unawaited(_confirmRemoveItem(item)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
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
                  onMinus: () => _changeQty(item, -1),
                  onPlus: () => _changeQty(item, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 98.w,
        height: 62.h,
        color: const Color(0xFF111111),
        child: imageUrl.trim().isEmpty
            ? Center(
                child: Image.asset(
                  'assets/svg/logo.png',
                  width: 46.w,
                  height: 46.w,
                  fit: BoxFit.contain,
                ),
              )
            : CustomNetworkImage(
                imageUrl: imageUrl,
                width: 98.w,
                height: 62.h,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildItemInfo(CartItem item, {required bool showOriginal}) {
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
              '¥${_formatYuan(item.price)}',
              style: TextStyle(
                fontSize: 16.sp,
                color: _brandRed,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(8.w),
            if (showOriginal)
              Text(
                '¥${_formatYuan(item.originalPrice)}',
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

  Widget _buildBottomBar({
    required bool isAllSelected,
    required double selectedTotal,
    required int selectedLineCount,
    required bool hasAnySelected,
    required VoidCallback onToggleSelectAll,
  }) {
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
                onTap: onToggleSelectAll,
                child: Row(
                  children: [
                    _SquareCheck(checked: isAllSelected),
                    Gap(8.w),
                    Text('全选', style: TextStyle(fontSize: 13.sp, color: _textMain)),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('合计', style: TextStyle(fontSize: 11.sp, color: _textSub)),
                  Text(
                    '¥${_formatYuan(selectedTotal)}',
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26.r)),
                elevation: 0,
              ),
              onPressed: hasAnySelected ? () {} : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department_outlined, size: 18.sp),
                  Gap(6.w),
                  Text(
                    '提交订单（$selectedLineCount）',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatYuan(double value) {
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.000001) return rounded.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }
}

class _SquareCheck extends StatelessWidget {
  const _SquareCheck({required this.checked});
  final bool checked;

  @override
  Widget build(BuildContext context) {
    final borderColor = checked ? const Color(0xFF6B6B6B) : const Color(0xFFBDBDBD);
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: checked ? Icon(Icons.check, size: 14.sp, color: borderColor) : const SizedBox.shrink(),
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
    final minusEnabled = value > 1;
    return Row(
      children: [
        _StepperCircle(
          icon: Icons.remove,
          onTap: onMinus,
          enabled: minusEnabled,
        ),
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
  const _StepperCircle({
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bg = enabled ? const Color(0xFFF1F1F1) : const Color(0xFFF6F6F6);
    final fg = enabled ? const Color(0xFF8D8D8D) : const Color(0xFFCDCDCD);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Icon(icon, size: 16.sp, color: fg),
      ),
    );
  }
}
