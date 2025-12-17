import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/product_model.dart';

import 'detail_controller.dart';


class DetailView extends StatefulWidget {
  final String productId;
  const DetailView({super.key, required this.productId});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final DetailController controller = Get.put(DetailController());
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    controller.loadProduct(widget.productId);
    
    // Initialize video if available
    ever<Product?>(controller.product, (product) {
      if (product?.videoUrl != null) {
        _initializePlayer(product!.videoUrl!);
      }
    });

  }

  Future<void> _initializePlayer(String url) async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return const Center(child: Text('Video load failed', style: TextStyle(color: Colors.white)));
      },
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) return const Center(child: CircularProgressIndicator());

        return Column(

          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                          ? Chewie(controller: _chewieController!)
                          : Image.network(product.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: Theme.of(context).textTheme.displayLarge),
                          const SizedBox(height: 8),
                          Text('¥${product.price}', style: const TextStyle(color: AppTheme.primaryRed, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          const Text('Specifications', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: product.specs.map((spec) {
                              final isSelected = controller.selectedSpec.value == spec;
                              return ChoiceChip(
                                label: Text(spec),
                                selected: isSelected,
                                selectedColor: AppTheme.primaryRed,
                                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                                onSelected: (selected) {
                                  if (selected) controller.selectSpec(spec);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          MarkdownBody(data: product.description),
                          const SizedBox(height: 80), // Space for bottom bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => context.push('/cart')), // Corrected: context.push requires go_router import, but here we can just use Get or Navigator if context available. Wait, we use go_router.
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.addToCart();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGold),
                  child: const Text('Add to Cart'),
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // controller.buyNow(); // Move logic here or keep in controller but handle UI here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacting Seller...')),
                    );
                  },
                  child: const Text('Buy Now'),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


