// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/screens/Screen_adminpages/screen_admin.dart';
import 'package:travelmate/firebase/firebase_functions/firestore_services.dart';
import '../../db/model/model_destination/model_destination.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AuthFunctinos {
  static Future<int> signupUser(
      String name, String email, String password, BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return 0;
    }
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FireStoreServices.saveUser(
          name, email, password, userCredential.user!.uid);
      return 1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 2;
      } else if (e.code == 'email-already-in-use') {
        return 3;
      }
    } catch (e) {
      return 4;
    }
    return 4;
  }

  static signinAdmin(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ScreenAdmin(),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == '') {}
    }
  }

  static Future<int> signIn(
      String email, String password, BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return 0;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user!.uid == 'EQv2jxY4JtW94G8tNOxriloyRNt1'
          ? 11
          : 1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 2;
      } else if (e.code == 'wrong-password') {
        return 3;
      } else {
        return 4;
      }
    }
  }

  static Future<int> signoutUser(context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return 0;
    }
    await FirebaseAuth.instance.signOut();
    return 1;
  }
}

final ValueNotifier<List<ModelDestination>> allDestinations =
    ValueNotifier<List<ModelDestination>>([]);

final ValueNotifier<List<ModelDestination>> filteredDestination =
    ValueNotifier<List<ModelDestination>>([]);

final ValueNotifier<List<ModelDestination>> filteredDestinationByCategory =
    ValueNotifier<List<ModelDestination>>([]);

// Function to fetch destinations for the selected category from Firestore

void getDestinationsForCategory(String category) {
  FirebaseFirestore.instance
      .collection('destinations')
      .where('category', isEqualTo: category)
      .get()
      .then((querySnapshot) {
    List<ModelDestination> destinations = [];

    for (var doc in querySnapshot.docs) {
      destinations.add(ModelDestination(
        id: doc['id'],
        destinationName: doc['name'],
        destinationDistrict: doc['district'],
        destinationCategory: doc['category'],
        destinationLocation: doc['location'],
        destinationDescription: doc['description'],
        destinationImageUrls: List<String>.from(doc['ImageUrls']),
      ));
    }
    filteredDestinationByCategory.value = destinations;
  });
}
