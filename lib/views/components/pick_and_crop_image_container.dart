import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../handlers/padding_handler.dart';
import '../../commons/app_color.dart';
import '../../handlers/image_handler.dart';
import '../../viewModels/image_view_model.dart';

class PickAndCropImageContainer extends ConsumerWidget {
  final int index;

  const PickAndCropImageContainer({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageList = ref.watch(imageListProvider);

    /// 削除ボタン
    Widget deleteButton() {
      return Container(
        width: getW(context, 12),
        padding: EdgeInsets.only(right: getW(context, 3), top: 0),
        child: FloatingActionButton(
          onPressed: () {
            /// ImageModelのリストから削除
            ref.read(imageListProvider.notifier).remove(index);
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.clear_rounded, color: textIconColor,),
        ),
      );
    }

    /// 切り抜き画像がある場合のデザイン
    Widget image() {
      return SizedBox(
        width: getW(context, 40),
        height: getH(context, 30),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Image.memory(imageList[index].imageFile),
            deleteButton(),
          ],
        ),
      );
    }

    return Container(
      width: getW(context, 40),
      height: getW(context, 30),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: textIconColor),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageList.length >= index + 1
        ? image()
        : IconButton(
          color: textIconColor,
          onPressed: () {
            pickAndCropImage(ref);
          },
          icon: const Icon(
          Icons.camera_alt_rounded,
          size: 34,
        ),
      )
    );
  }






}