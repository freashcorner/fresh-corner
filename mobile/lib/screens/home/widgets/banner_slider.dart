import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final _ctrl = PageController();
  int _current = 0;

  static const _banners = [
    _BannerData(
      title: 'তাজা সবজি ১০% ছাড়',
      subtitle: 'আজকের অফার — সীমিত সময়',
      emoji: '🥦',
      color1: Color(0xFFFF6B35),
      color2: Color(0xFFFF8C61),
    ),
    _BannerData(
      title: 'বিনামূল্যে ডেলিভারি',
      subtitle: '৫০০ টাকার উপরে অর্ডারে',
      emoji: '🚚',
      color1: Color(0xFF2ECC71),
      color2: Color(0xFF27AE60),
    ),
    _BannerData(
      title: 'ফ্রেশ ফলমূল',
      subtitle: 'প্রতিদিন সংগ্রহ করা তাজা ফল',
      emoji: '🍎',
      color1: Color(0xFF3498DB),
      color2: Color(0xFF5DADE2),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    final next = (_current + 1) % _banners.length;
    _ctrl.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _banners.length,
            itemBuilder: (_, i) => _BannerCard(data: _banners[i]),
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _ctrl,
          count: _banners.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Color(0xFF2ECC71),
            dotColor: Color(0xFFD5F5E3),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title, subtitle, emoji;
  final Color color1, color2;
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color1,
    required this.color2,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [data.color1, data.color2]),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(data.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(data.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('এখনই দেখুন', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(data.emoji, style: TextStyle(fontSize: 44, color: Colors.white.withOpacity(0.35))),
            ),
          ),
        ],
      ),
    );
  }
}
