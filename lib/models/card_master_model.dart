import 'package:cloud_firestore/cloud_firestore.dart';

class CardMaster {
  final String? serialNumber;
  final String? prefecture;
  final String? city;
  final int? version;
  final String? issueDate;
  final String? comment;
  final String? stockLink;
  final List<String>? distributeLocations;
  final List<String>? distributeAddresses;
  final List<String>? locationLinks;

  CardMaster({
    this.serialNumber,
    this.prefecture,
    this.city,
    this.version,
    this.issueDate,
    this.comment,
    this.stockLink,
    this.distributeLocations,
    this.distributeAddresses,
    this.locationLinks,
  });

  factory CardMaster.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CardMaster(
      serialNumber: data?['serial_number'],
      prefecture: data?['prefecture'],
      city: data?['city'],
      version: data?['version'],
      issueDate: data?['issue_date'],
      comment: data?['comment'],
      stockLink: data?['stock_link'],
      distributeLocations: data?['distribute_locations'],
      distributeAddresses: data?['location_links'],
      locationLinks: data?['distribute_addresses'],
    );
  }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (serialNumber != null) 'serial_number': serialNumber,
  //     if (prefecture != null) 'prefecture': prefecture,
  //     if (city != null) 'city': city,
  //     if (version != null) 'version': version,
  //     if (issueDate != null) 'issue_date': issueDate,
  //     if (comment != null) 'comment': comment,
  //     if (stockLink != null) 'stock_link': stockLink,
  //     if (distributeLocation != null) 'distribute_location': distributeLocation,
  //     if (locationLink != null) 'distribute_address': locationLink,
  //     if (distributeAddress != null) 'location_link': distributeAddress,
  //   };
  // }
}
