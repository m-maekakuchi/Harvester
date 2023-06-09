import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String fileName;
  final String filePath;
  final Uint8List imageFile;

  ImageModel({
    required this.fileName,
    required this.filePath,
    required this.imageFile,
  });

  factory ImageModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return ImageModel(
      fileName: data?['file_name'],
      filePath: data?['file_path'],
      imageFile: data?['imageFile'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'file_name': fileName,
      'file_path': filePath,
      'imageFile': imageFile,
    };
  }
}
