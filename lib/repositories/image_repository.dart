import 'package:firebase_storage/firebase_storage.dart';

import '../models/image_model.dart';

class ImageRepository {

  Future uploadImageToFirebase(List<ImageModel> imageModelList) async {
    for (ImageModel imageModel in imageModelList) {
      // アップロードしたいファイルのパス
      Reference storageRef = FirebaseStorage.instance.ref().child(imageModel.filePath);
      // アップロードしたいファイルのメタデータ
      final metadata = SettableMetadata(contentType: "image/jpeg");

      final uploadTask = storageRef
          .child(imageModel.fileName)
          .putData(imageModel.imageFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
          // Handle unsuccessful uploads
            break;
          case TaskState.success:
          // Handle successful uploads on complete
          // ...
            break;
        }
      });
    }
  }
}