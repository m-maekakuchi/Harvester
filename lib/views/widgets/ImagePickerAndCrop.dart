import 'dart:io';

import 'package:flutter/material.dart';
import 'package:harvester/commons/app_color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../handlers/padding_handler.dart';

class ImagePickAndCrop extends StatefulWidget {

  const ImagePickAndCrop({super.key});

  @override
  _ImagePickAndCrop createState() => _ImagePickAndCrop();
}

class _ImagePickAndCrop extends State<ImagePickAndCrop> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getW(context, 40),
        height: getW(context, 30),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: textIconColor),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: _croppedFile == null
            ? IconButton(
          color: textIconColor,
          onPressed: () {
            _uploadImage();
          },
          icon: const Icon(
            Icons.camera_alt_rounded,
            size: 34,
          ),
        )
            : _image()
    );
  }

  // 切り抜き画像がある場合のデザイン
  Widget _image() {
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return SizedBox(
        width: getW(context, 40),
        height: getH(context, 30),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Image.file(File(path)),
            _deleteButton(),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // 削除ボタン
  Widget _deleteButton() {
    return Container(
      width: getW(context, 12),
      padding: EdgeInsets.only(right: getW(context, 3), top: 0),
      child: FloatingActionButton(
        onPressed: () {
          _clear();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.clear_rounded, color: textIconColor,),
      ),
    );
  }

  // ギャラリーから画像を取得
  Future<void> _uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
    await _cropImage();
  }

  // 画像の切り抜き
  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
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
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}