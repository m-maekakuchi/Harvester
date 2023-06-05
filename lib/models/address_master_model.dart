import 'package:cloud_firestore/cloud_firestore.dart';

class AddressMaster {
  final List<String>? prefectures;

  AddressMaster({
    this.prefectures,
  });

  factory AddressMaster.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AddressMaster(
      prefectures: data?['prefectures'],
    );
  }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (prefectures != null) 'prefecture': prefectures,
  //   };
  // }
}
