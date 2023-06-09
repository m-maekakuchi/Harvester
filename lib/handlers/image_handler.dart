import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../models/image_model.dart';
import '../viewModels/auth_view_model.dart';
import '../viewModels/image_view_model.dart';

// 画像の圧縮
Future<Uint8List?> compressFile(File file) async{
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    quality: 20,
  );
  return result;
}

// 切り抜きをした画像をViewModelに追加
Future<void> addImageToImageList(CroppedFile croppedFile, WidgetRef ref) async {
  final firebaseAuthUid = ref.read(authViewModelProvider.notifier).getUid();
  final fileName = croppedFile.path;

  final Uint8List? compressedFile = await compressFile(File(croppedFile.path));

  final imageModel = ImageModel(
    fileName: fileName,
    filePath: firebaseAuthUid,
    imageFile: compressedFile!,
  );
  ref.read(imageListProvider.notifier).add(imageModel);
}

// ギャラリーの画像の取得と、画像の切り抜き
Future<void> pickAndCropImage(WidgetRef ref) async {
  // 画像の取得
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    // 画像の切り抜き
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 4.0, ratioY: 3.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '画像の切り抜き',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true
        ),
        IOSUiSettings(
          title: '画像の切り抜き',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
          doneButtonTitle: "完了",
          cancelButtonTitle: "キャンセル",
        ),
      ],
    );

    if (croppedFile != null) {
      addImageToImageList(croppedFile, ref);
    }
  }
}