import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../commons/address_master.dart';
import '../../commons/irregular_card_number.dart';
import '../../models/card_master_model.dart';

CachedNetworkImage cachedNetworkImage(String imgUrl, CardMasterModel cardMasterModel) {
  return CachedNetworkImage(
    imageUrl: imgUrl,
    placeholder: (context, url) { // 読み込み中
      /// Shimmerに後で変更する
      return irregularCardMasterNumbers.containsValue(cardMasterModel.serialNumber)
        ? Image.asset('images/irregular.png')
        : Image.asset('images/${regionEngMap[cardMasterModel.prefecture]}.png');
    },
    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error_rounded)),
  );
}