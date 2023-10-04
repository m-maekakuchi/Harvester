import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _kItemExtent = 32.0;

class ItemCupertinoPicker extends ConsumerWidget {

  final List<String> itemAry;
  final StateProvider provider;

  const ItemCupertinoPicker({
    super.key,
    required this.itemAry,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final initIndex =  ref.watch(provider);

    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: _kItemExtent,
      backgroundColor: isDarkMode ? Colors.black : null,
      scrollController: FixedExtentScrollController(
        initialItem: initIndex,
      ),
      // 項目が選択された場合
      onSelectedItemChanged: (int selectedItemIndex) {
        final notifier = ref.read(provider.notifier);
        notifier.state = selectedItemIndex;
      },
      children:
      List<Widget>.generate(itemAry.length, (int index) {
        return Text(
          itemAry[index],
        );
      }),
    );
  }
}
