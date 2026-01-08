import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BannerModel {
  final String imageUrl;
  final String actionType;
  final String actionValue;

  BannerModel(
      {required this.imageUrl,
      required this.actionType,
      required this.actionValue});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      imageUrl: json['image_url'],
      actionType: json['action_type'],
      actionValue: json['action_value'],
    );
  }
}

class BannerSlider extends StatefulWidget {
  final String apiUrl;
  const BannerSlider({Key? key, required this.apiUrl}) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  List<BannerModel> banners = [];
  int currentIndex = 0;
  PageController pageController = PageController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void fetchBanners() async {
    final response = await http.get(Uri.parse(widget.apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        banners = data.map((e) => BannerModel.fromJson(e)).toList();
      });
      startAutoScroll();
    }
  }

  void startAutoScroll() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 4), (Timer t) {
      if (banners.isNotEmpty) {
        int nextIndex = (currentIndex + 1) % banners.length;
        pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onBannerTap(BannerModel banner) {
    switch (banner.actionType) {
      case 'screen':
        // Navegar para tela
        Navigator.pushNamed(context, banner.actionValue);
        break;
      case 'link':
        // Abrir link externo
        // Use url_launcher package
        break;
      case 'recharge':
        // Executar ação de recarga
        // Implemente conforme sua lógica
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const SizedBox(
          height: 160, child: Center(child: CircularProgressIndicator()));
    }
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = banners[index];
                return GestureDetector(
                  onTap: () => onBannerTap(banner),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      banner.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentIndex == index ? 12 : 8,
                height: currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
