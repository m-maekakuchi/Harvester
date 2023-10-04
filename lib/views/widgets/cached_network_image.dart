import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harvester/commons/app_color.dart';

import 'modal_barrier.dart';

CachedNetworkImage cachedNetworkImage(String imgUrl) {
  return CachedNetworkImage(
    fit: BoxFit.cover,
    imageUrl: imgUrl,
    placeholder: (context, url) { // 読み込み中
      return const Center(child: modalBarrier);
    },
    errorWidget: (context, url, error) {
      bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

      return Center(child: Icon(
        Icons.error_rounded,
        color: isDarkMode ? Colors.white : textIconColor,
      ));
    }
  );
}