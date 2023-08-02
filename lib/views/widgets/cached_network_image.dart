import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage cachedNetworkImage(String imgUrl) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    placeholder: (context, url) => Image.asset('images/GrayBackImg.png'),
    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error_rounded)),
  );
}