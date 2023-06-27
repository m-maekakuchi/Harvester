import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handlers/padding_handler.dart';
import '../widgets/accordion.dart';

class AccordionCardMasters extends ConsumerWidget {

  final StateProvider provider;
  final Map<String, List<String>> cardMasterMap;

  const AccordionCardMasters({
    super.key,
    required this.provider,
    required this.cardMasterMap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          height: getH(context, 6),
          alignment: Alignment.center,
          child: const Text("カードの選択", style: TextStyle(fontSize: 16),)
        ),
        Expanded( // スクロールさせる領域をExpandedで囲むと、それ以外が固定になる
          child: SingleChildScrollView(
            child: Column(
              children: cardMasterMap.entries.map((entry) {
                String key = entry.key;
                List<String> value = entry.value;
                return Accordion(
                  title: key,
                  tileTextList: value,
                  provider: provider,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
