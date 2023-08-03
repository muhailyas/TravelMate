import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../db/model/model_destination/model_destination.dart';
import '../screens/login_screen/screen_login.dart';

class FavoriteModel extends ChangeNotifier {
  List<String> favorites = [];
  ValueNotifier<List<ModelDestination>> favoritesListenable = ValueNotifier([]);

  Future<void> initFavorites(String userId) async {
    final favoritesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    favorites =
        favoritesSnapshot.docs.map((destination) => destination.id).toList();

    final favoriteDestinations = await Future.wait(favorites.map(
        (destinationId) => FirebaseFirestore.instance
            .collection('destinations')
            .doc(destinationId)
            .get()));

    final favoriteDestinationData = favoriteDestinations.map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      return ModelDestination(
        id: snapshot.id,
        destinationName: data['name'],
        destinationDistrict: data['district'],
        destinationCategory: data['category'],
        destinationLocation: data['location'],
        destinationDescription: data['description'],
        destinationImageUrls: List<String>.from(data['ImageUrls']),
      );
    }).toList();

    favoritesListenable.value = favoriteDestinationData;
  }

  void addFavorite(String destinationId) {
    if (!favorites.contains(destinationId)) {
      favorites.add(destinationId);
      notifyListeners();
      // Add the favorite to Firebase here using the current user's ID
      if (currentUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('favorites')
            .doc(destinationId)
            .set({'timestamp': FieldValue.serverTimestamp()});
      }
    }
  }

  void removeFavorite(String destinationId) {
    if (favorites.contains(destinationId)) {
      favorites.remove(destinationId);
      notifyListeners();
      // Remove the favorite from Firebase here using the current user's ID
      if (currentUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('favorites')
            .doc(destinationId)
            .delete();
      }
    }
  }
}
