import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  return DateFormat('yyyy/MM/dd').format(dateTime);
}

List<PhotoModel> convertListData(List<ImageModel> imageModelList, Ref ref) {
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
