import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/address_master.dart';
import '../../commons/irregular_card_number.dart';
import '../../handlers/padding_handler.dart';
import '../../models/card_master_model.dart';
import '../../provider/providers.dart';
import 'cached_network_image.dart';

class CarouselSliderPhotos extends ConsumerWidget {

  final List<String?>? imgUrlList;
  final CardMasterModel cardMasterModel;

  CarouselSliderPhotos({
    super.key,
    required this.cardMasterModel,
    required this.imgUrlList
  });

  // カルーセルのコントローラー
  final CarouselController _controller = CarouselController();

  // スライドする画像のリスト
  List<Widget> imageSliderList(BuildContext context) {
    List<Widget> imgSliders = [];
    if (imgUrlList != null) {
      for (String? imgUrl in imgUrlList!) {
        if (imgUrl != null) {
          final imgWidget = ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: cachedNetworkImage(imgUrl, cardMasterModel),
          );
          imgSliders.add(imgWidget);
        }
      }
    }
    // imgSlidersが空の場合（マイカード登録がない or マイカード登録しているが画像が取得できなかった）
    if (imgSliders.isEmpty) {
      final imgWidget = ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        // カード番号がirregularの番号の場合はベージュのカードの画像、それ以外はその地方の色のカード画像
        child: irregularCardMasterNumbers.containsValue(cardMasterModel.serialNumber)
          ? Image.asset('images/irregular.png')
          : Image.asset('images/${regionMap[cardMasterModel.prefecture]}.png'),
      );
      imgSliders.add(imgWidget);
    }
    return imgSliders;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicatorIndex = ref.watch(carouselSliderIndexProvider);

    // 写真下部にある黒丸
    Widget blackCircle(MapEntry<int, Widget> entry) {
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
              .withOpacity(indicatorIndex == entry.key ? 0.9 : 0.4)
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: getH(context, 2),
        ),
        CarouselSlider(
          items: imageSliderList(context),
          carouselController: _controller,
          options: CarouselOptions(
            viewportFraction: 0.7,        // 左右のカードがどのくらい見えるかのバランスを決める
            aspectRatio: 4.0 / 3.0 / 0.7,
            enableInfiniteScroll: false,  // 無限スクロールしない
            reverse: false,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              ref.watch(carouselSliderIndexProvider.notifier).state = index;
            }
          ),
        ),
        // 写真下部にある黒丸
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageSliderList(context).asMap().entries.map((entry) =>
            blackCircle(entry)
          ).toList(),
        ),
      ],
    );
  }
}
