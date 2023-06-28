import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handlers/padding_handler.dart';
import '../widgets/accordion.dart';

class AccordionPrefectures extends ConsumerWidget {

  final StateProvider provider;

  const AccordionPrefectures({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          height: getH(context, 6),
          alignment: Alignment.center,
          child: const Text("都道府県の選択", style: TextStyle(fontSize: 16),)
        ),
        Expanded( // スクロールさせる領域をExpandedで囲むと、それ以外が固定になる
          child: SingleChildScrollView(
            child: Column(
              children: [
                Accordion(
                  title: '北海道',
                  tileTextList: const [
                    '北海道'
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '東北',
                  tileTextList: const [
                    '青森県',
                    '岩手県',
                    '宮城県',
                    '秋田県',
                    '山形県',
                    '福島県',
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '関東',
                  tileTextList: const [
                    '茨城県',
                    '栃木県',
                    '群馬県',
                    '埼玉県',
                    '千葉県',
                    '東京都',
                    '神奈川県',
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '中部',
                  tileTextList: const [
                    '新潟県',
                    '富山県',
                    '石川県',
                    '福井県',
                    '山梨県',
                    '長野県',
                    '岐阜県',
                    '静岡県',
                    '愛知県',
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '近畿',
                  tileTextList: const [
                    '三重県',
                    '滋賀県',
                    '京都府',
                    '大阪府',
                    '兵庫県',
                    '奈良県',
                    '和歌山県',
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '中国',
                  tileTextList: const [
                    '鳥取県',
                    '島根県',
                    '岡山県',
                    '広島県',
                    '山口県',
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '四国',
                  tileTextList: const [
                    '徳島県',
                    '香川県',
                    '愛媛県',
                    '高知県',
                  ],
                  provider: provider,
                ),
                Accordion(
                  title: '九州',
                  tileTextList: const [
                    '福岡県',
                    '佐賀県',
                    '長崎県',
                    '熊本県',
                    '大分県',
                    '宮崎県',
                    '鹿児島県',
                    '沖縄県',
                  ],
                  provider: provider,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
