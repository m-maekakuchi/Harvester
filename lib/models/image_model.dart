import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String? fileName;
  late String? filePath;
  final Uint8List? imageFile;

  ImageModel({
    this.fileName,
    this.filePath,
    this.imageFile,
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
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (imageFile != null) 'imageFile': imageFile,
    };
  }
}
