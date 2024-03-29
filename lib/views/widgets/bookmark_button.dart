import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/app_color.dart';
import '../../handlers/padding_handler.dart';

class BookMarkButton extends ConsumerWidget {

  final StateProvider provider;

  const BookMarkButton({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final bookmark = ref.watch(provider);
    return IconButton(
      onPressed: () {
        final notifier = ref.read(provider.notifier);
        notifier.state = !bookmark;
      },
      iconSize: 40,
      icon: Icon(
        bookmark ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
      ),
      color: bookmark
        ? favoriteColor
        :  isDarkMode ? Colors.white : textIconColor,
    );
  }
}
