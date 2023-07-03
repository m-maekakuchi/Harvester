import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image_model.dart';
import '../models/photo_model.dart';
import '../viewModels/auth_view_model.dart';

DateTime convertStringToDateTime(String dateString) {
  List<String> parts = dateString.split('/');
  int year = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int day = int.parse(parts[2]);
  return DateTime(year, month, day);
}

String convertDateTimeToString(DateTime dateTime) {
  final formattedDate = '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  return formattedDate;
}

List<PhotoModel> convertListData(List<ImageModel> imageModelList, WidgetRef ref) {
  final uid = ref.read(authViewModelProvider.notifier).getUid();
  final now = DateTime.now();
  List<PhotoModel> photoModelList = [];
  for (var element in imageModelList) {
    photoModelList.add(PhotoModel(
      firebaseAuthUid: uid,
      fileName: element.fileName,
      filePath: element.filePath,
      createdAt: now,
    ));
  }
  return photoModelList;
}
