import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/model/model_destination/model_destination.dart';
import '../firebase/firebase_functions/firebase_functions.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DestinationRepository {
  Future<List<ModelDestination>> fetchDestinations() async {
    final collection = FirebaseFirestore.instance.collection('destinations');
    final querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ModelDestination(
        id: doc.id,
        destinationName: data['name'],
        destinationDistrict: data['district'],
        destinationCategory: data['category'],
        destinationLocation: data['location'],
        destinationDescription: data['description'],
        destinationImageUrls: List<String>.from(data['ImageUrls']),
      );
    }).toList();
  }

  void getAllDatas() async {
    final destinations = await fetchDestinations();
    allDestinations.value = destinations;
  }

  addDestination({required ModelDestination modelDestination}) async {
    final CollectionReference destination =
        FirebaseFirestore.instance.collection('destinations');
    DocumentReference newDestination = destination.doc();
    Map<String, dynamic> newDestinationDetails = {
      'id': newDestination.id,
      'name': modelDestination.destinationName,
      'district': modelDestination.destinationDistrict,
      'category': modelDestination.destinationCategory,
      'location': modelDestination.destinationLocation,
      'description': modelDestination.destinationDescription,
      'ImageUrls': modelDestination.destinationImageUrls,
    };
    await newDestination.set(newDestinationDetails);
  }

  //updateDestination

  Future<void> updateDestination(ModelDestination modelDestination) async {
    final CollectionReference destination =
        FirebaseFirestore.instance.collection('destinations');
    Map<String, dynamic> updatedDestinationDetails = {
      'name': modelDestination.destinationName,
      'district': modelDestination.destinationDistrict,
      'category': modelDestination.destinationCategory,
      'location': modelDestination.destinationLocation,
      'description': modelDestination.destinationDescription,
      'ImageUrls': modelDestination.destinationImageUrls,
    };
    await destination
        .doc(modelDestination.id)
        .update(updatedDestinationDetails);
  }

  Future<void> deleteDestination(String destinationId) async {
    final CollectionReference destination =
        FirebaseFirestore.instance.collection('destinations');

    // Step 1: Fetch the list of image URLs associated with the destination

    DocumentSnapshot destinationSnapshot =
        await destination.doc(destinationId).get();

    List<String> imageUrls =
        List<String>.from(destinationSnapshot.get('ImageUrls') ?? <String>[]);

    // Step 2: Delete the document from the 'destinations' collection in Firestore
    await destination.doc(destinationId).delete();

    // Step 3: Delete the images from Firebase Storage using their URLs

    for (String imageUrl in imageUrls) {
      try {
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
      } catch (error) {
        if (error == error) {}
      }
    }
  }

  // filtering

  Future<List<ModelDestination>> filterDestinations({
    List<String>? selectedDistricts,
    List<String>? selectedCategories,
  }) async {
    selectedDistricts ??= [];
    selectedCategories ??= [];

    final collection = FirebaseFirestore.instance.collection('destinations');
    Query query = collection;

    // When no district or category is selected
    if (selectedDistricts.isEmpty && selectedCategories.isEmpty) {
      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ModelDestination(
          id: doc.id,
          destinationName: data['name'],
          destinationDistrict: data['district'],
          destinationCategory: data['category'],
          destinationLocation: data['location'],
          destinationDescription: data['description'],
          destinationImageUrls: List<String>.from(data['ImageUrls']),
        );
      }).toList();
    }
    // Only district selected
    else if (selectedDistricts.isNotEmpty && selectedCategories.isEmpty) {
      final querySnapshot =
          await query.where('district', whereIn: selectedDistricts).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ModelDestination(
          id: doc.id,
          destinationName: data['name'],
          destinationDistrict: data['district'],
          destinationCategory: data['category'],
          destinationLocation: data['location'],
          destinationDescription: data['description'],
          destinationImageUrls: List<String>.from(data['ImageUrls']),
        );
      }).toList();
    }
    // Only category selected
    else if (selectedDistricts.isEmpty && selectedCategories.isNotEmpty) {
      final querySnapshot =
          await query.where('category', whereIn: selectedCategories).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ModelDestination(
          id: doc.id,
          destinationName: data['name'],
          destinationDistrict: data['district'],
          destinationCategory: data['category'],
          destinationLocation: data['location'],
          destinationDescription: data['description'],
          destinationImageUrls: List<String>.from(data['ImageUrls']),
        );
      }).toList();
    }
    // Both district and category selected
    else {
      final querySnapshot =
          await query.where('district', whereIn: selectedDistricts).get();

      final filteredDocs = querySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final destinationCategory = data['category'] as String?;
        return selectedCategories!.contains(destinationCategory);
      }).toList();

      return filteredDocs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ModelDestination(
          id: doc.id,
          destinationName: data['name'],
          destinationDistrict: data['district'],
          destinationCategory: data['category'],
          destinationLocation: data['location'],
          destinationDescription: data['description'],
          destinationImageUrls: List<String>.from(data['ImageUrls']),
        );
      }).toList();
    }
  }

  getfiltered() async {
    List<ModelDestination> filteredDestinations = await DestinationRepository()
        .filterDestinations(
            selectedCategories: selectedCategoriesFB,
            selectedDistricts: selectedDistrictsFB);
    filteredDestination.value = filteredDestinations;
  }
}

List<String>? selectedDistrictsFB = [];
List<String>? selectedCategoriesFB = [];
