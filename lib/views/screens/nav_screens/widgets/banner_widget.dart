import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/providers/banner_provider.dart';
import '../../../../controls/banner_controller.dart';

class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    final banners = ref.read(bannerProvider);
    if (banners.isEmpty) {
      _fetchBanners();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchBanners() async {
    final BannerController bannerController = BannerController();
    try {
      final banners = await bannerController.loadBanners();
      ref.read(bannerProvider.notifier).setBanners(banners);
    } catch (e) {
      throw Exception("Error fetching in banners $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xfff7f7f7)),
        child: PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      banner.image,
                      fit: BoxFit.cover,
                    ),
                  );
          },
        ));
  }
}
