import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/product_model.dart';
import '../../core/widget/custom_network_image.dart';

import 'detail_controller.dart';

class DetailView extends StatefulWidget {
  final String productId;
  const DetailView({super.key, required this.productId});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final DetailController controller = Get.put(DetailController());
  final PageController _pageController = PageController();
  int _mediaIndex = 0;

  VideoPlayerController? _videoController;
  Worker? _productWorker;

  @override
  void initState() {
    super.initState();
    controller.loadProduct(widget.productId);

    // Initialize video if available.
    _productWorker = ever<Product?>(controller.product, (product) {
      final url = product?.videoUrl;
      if (url == null || url.trim().isEmpty) {
        _disposeVideo();
        return;
      }
      _initializeVideo(url);
      if (mounted) {
        setState(() {
          _mediaIndex = 0;
        });
      }
    });
  }

  Future<void> _initializeVideo(String url) async {
    _disposeVideo();
    final next = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoController = next;
    try {
      await next.initialize();
      await next.setLooping(true);
    } catch (_) {
      _disposeVideo();
      return;
    }
    if (mounted) setState(() {});
  }

  void _disposeVideo() {
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  void dispose() {
    _productWorker?.dispose();
    _pageController.dispose();
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          '产品详情',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分享功能开发中')),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentPrice = product.activityPrice ?? product.price;
        final originalPrice = product.activityPrice != null ? product.price : null;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildMediaSection(product),
            const SizedBox(height: 10),
            _buildInfoSection(product, currentPrice, originalPrice),
            const SizedBox(height: 10),
            _buildSpecSection(currentPrice),
            const SizedBox(height: 10),
            _buildDetailSection(product),
            const SizedBox(height: 90),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildMediaSection(Product product) {
    final pages = <Widget>[];
    final hasVideo = product.videoUrl != null && product.videoUrl!.trim().isNotEmpty;
    if (hasVideo) {
      pages.add(_buildVideoPreview());
    }
    pages.add(
      CustomNetworkImage(
        imageUrl: product.imageUrl,
        fit: BoxFit.cover,
      ),
    );

    return Container(
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (idx) {
                setState(() => _mediaIndex = idx);
                if (idx != 0 && _videoController?.value.isPlaying == true) {
                  _videoController?.pause();
                }
              },
              children: pages
                  .map((w) => Container(color: Colors.black, child: w))
                  .toList(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: _DotsIndicator(
                count: pages.length,
                index: _mediaIndex.clamp(0, pages.length - 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    final vc = _videoController;
    if (vc == null || !vc.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: vc.value.size.width,
              height: vc.value.size.height,
              child: VideoPlayer(vc),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (vc.value.isPlaying) {
                  await vc.pause();
                } else {
                  await vc.play();
                }
                if (mounted) setState(() {});
              },
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: vc.value.isPlaying ? 0.0 : 1.0,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppTheme.primaryRed,
                      size: 42,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(Product product, double currentPrice, double? originalPrice) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              _TagPill(text: '热销'),
              SizedBox(width: 8),
              _TagPill(text: '新品'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${_formatMoney(currentPrice)}',
                style: const TextStyle(
                  color: AppTheme.primaryRed,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '起',
                  style: TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (originalPrice != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '¥${_formatMoney(originalPrice)}',
                    style: const TextStyle(
                      color: AppTheme.textGrey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                size: 16,
                color: AppTheme.accentGold,
              ),
              const SizedBox(width: 4),
              Text(
                '热度 ${_formatCount(product.heat)}',
                style: const TextStyle(
                  color: AppTheme.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.inventory_2_outlined,
                size: 16,
                color: AppTheme.textGrey,
              ),
              const SizedBox(width: 4),
              Text(
                '已售 ${_formatCount(product.salesCount)}',
                style: const TextStyle(
                  color: AppTheme.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecSection(double currentPrice) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择规格',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '尺寸',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.sizeOptions.map((size) {
              final selected = controller.selectedSize.value == size;
              final label = '$size - ¥${_formatMoney(currentPrice)}';
              return _SpecChip(
                label: label,
                selected: selected,
                onTap: () => controller.selectSize(size),
              );
            }).toList(),
          ),
          if (controller.shotOptions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '发射数量',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.shotOptions.map((shots) {
                final selected = controller.selectedShots.value == shots;
                return _SpecChip(
                  label: shots,
                  selected: selected,
                  onTap: () => controller.selectShots(shots),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailSection(Product product) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '产品详情',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          MarkdownBody(
            data: product.description,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _ActionButton(
                backgroundColor: const Color(0xFFFFA726),
                icon: Icons.shopping_cart_outlined,
                label: '加入购物车',
                onTap: () async {
                  await controller.addToCart();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已加入购物车')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                backgroundColor: const Color(0xFFFF5A6A),
                icon: Icons.flash_on,
                label: '立即下单',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('下单功能开发中')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatMoney(double value) {
    final v = value;
    if (v % 1 == 0) return v.toStringAsFixed(0);
    return v.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\\.$'), '');
  }

  static String _formatCount(num value) {
    if (value >= 100000000) {
      final s = (value / 100000000).toStringAsFixed(1);
      return '${s.endsWith('.0') ? s.substring(0, s.length - 2) : s}亿';
    }
    if (value >= 10000) {
      final s = (value / 10000).toStringAsFixed(1);
      return '${s.endsWith('.0') ? s.substring(0, s.length - 2) : s}万';
    }
    return value.toString();
  }
}

class _TagPill extends StatelessWidget {
  final String text;
  const _TagPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.primaryRed,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SpecChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = selected ? AppTheme.primaryRed : const Color(0xFFE6E6E6);
    final bg = selected ? AppTheme.primaryRed.withValues(alpha: 0.06) : Colors.white;
    final fg = selected ? AppTheme.primaryRed : const Color(0xFF333333);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int index;
  const _DotsIndicator({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: backgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
