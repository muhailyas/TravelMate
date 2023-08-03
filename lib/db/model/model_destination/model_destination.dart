import 'package:cloud_firestore/cloud_firestore.dart';

class ModelDestination {
  String? id;
  String destinationName;
  String destinationDistrict;
  String destinationCategory;
  String destinationLocation;
  String destinationDescription;
  List<String> destinationImageUrls;
  ModelDestination({
    this.id,
    required this.destinationName,
    required this.destinationDistrict,
    required this.destinationCategory,
    required this.destinationLocation,
    required this.destinationDescription,
    required this.destinationImageUrls,
  });

  factory ModelDestination.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ModelDestination(
      id: data['id'] ?? '',
      destinationName: data['name'] ?? '',
      destinationDistrict: data['district'] ?? '',
      destinationCategory: data['category'] ?? '',
      destinationLocation: data['location'] ?? '',
      destinationDescription: data['description'] ?? '',
      destinationImageUrls: List<String>.from(data['ImageUrls'] ?? []),
    );
  }
}
