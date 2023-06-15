import 'package:cloud_firestore/cloud_firestore.dart';

class CardMasterModel {
  final String serialNumber;
  final String prefecture;
  final String city;
  final int version;
  final String issueDay;
  final String comment;
  final String? stockLink;
  final List<String?> distributeLocations;
  final List<String?> distributeAddresses;
  final List<String?> locationLinks;

  CardMasterModel({
    required this.serialNumber,
    required this.prefecture,
    required this.city,
    required this.version,
    required this.issueDay,
    required this.comment,
    required this.stockLink,
    required this.distributeLocations,
    required this.distributeAddresses,
    required this.locationLinks,
  });

  factory CardMasterModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CardMasterModel(
      serialNumber: data?['serial_number'],
      prefecture: data?['prefecture'],
      city: data?['city'],
      version: data?['version'],
      issueDay: data?['issue_day'],
      comment: data?['comment'],
      stockLink: data?['stock_link'],
      distributeLocations: List.from(data?['distribute_locations']),
      distributeAddresses: List.from(data?['location_links']),
      locationLinks: List.from(data?['distribute_addresses']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'serial_number': serialNumber,
      'prefecture': prefecture,
      'city': city,
      'version': version,
      'issue_day': issueDay,
      'comment': comment,
      'stock_link': stockLink,
      'distribute_locations': distributeLocations,
      'distribute_addresses': distributeAddresses,
      'location_links': locationLinks,
    };
  }
}
