import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

Widget cardMasterOptionListView({
  required List<String> list,
  required WidgetRef ref,
  required StateProvider provider
}) {
  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          final cardIndexNotifier = ref.read(provider.notifier);
          cardIndexNotifier.state = index;
          context.pop();
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: getW(context, 5)),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: textIconColor, width: 0.1),
            ),
          ),
          height: getH(context, 6),
          child: Text(list[index]),
        ),
      );
    },
  );
}