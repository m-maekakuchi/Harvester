import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/address_master_list.dart';
import '../../commons/card_master_option_str_list.dart';
import '../../handlers/padding_handler.dart';
import '../widgets/accordion.dart';

class AccordionCardMasters extends ConsumerWidget {

  final StateProvider provider;

  const AccordionCardMasters({
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
          child: const Text("カードの選択", style: TextStyle(fontSize: 16),)
        ),
        Expanded( // スクロールさせる領域をExpandedで囲むと、それ以外が固定になる
          child: ListView.builder(
            itemCount: cardMasterOptionStrList.length,
            itemBuilder: (context, index) {
              return Accordion(
                title: addressList[index],
                tileTextList: cardMasterOptionStrList[index],
                provider: provider,
              );
            },
          ),
        ),
      ],
    );
  }
}
