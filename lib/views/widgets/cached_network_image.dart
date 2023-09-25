import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage cachedNetworkImage(String imgUrl) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    // placeholder: (context, url) { // 読み込み中
    //   return Container(
        // child: modalBarrier,
    //   );
    // },
    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error_rounded)),
  );
}