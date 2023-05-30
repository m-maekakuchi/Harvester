import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final indicatorIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class CarouselSliderPhotos extends ConsumerWidget {

  final List<String> imgList;

  CarouselSliderPhotos({
    super.key,
    required this.imgList
  });

  final CarouselController _controller = CarouselController();

  List<Widget> createImageSlider(List<String> imgList) {
    final List<Widget> imageSliders = imgList.map((item) => Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Image.network(item, fit: BoxFit.cover, width: 1000.0),
      ),
    )).toList();
    return imageSliders;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicatorIndex = ref.watch(indicatorIndexProvider);
    return Column(
      children: [
        CarouselSlider(
          items: createImageSlider(imgList),
          carouselController: _controller,
          options: CarouselOptions(
            enlargeCenterPage: true,
            // aspectRatio: 1.618,
            onPageChanged: (index, reason) {
              ref.watch(indicatorIndexProvider.notifier).state = index;
            }
          ),
        ),
        // 写真下部にある黒丸
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)
                    .withOpacity(indicatorIndex == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
