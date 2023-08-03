import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/db/model/model_destination/model_destination.dart';
import '../login_screen/screen_login.dart';

ValueNotifier<List<TripPlanModel>> getAllTripPlanNotifier =
    ValueNotifier<List<TripPlanModel>>([]);

class TripPlanRepository extends ChangeNotifier {
  getTripPlans() async {
    final allTripPlans = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .get();
    final allPlans = allTripPlans.docs.map((snapShot) {
      var plan = snapShot.data();
      return TripPlanModel(
          id: snapShot.id,
          tripName: plan['trip name'],
          startDate: (plan['start date'] as Timestamp).toDate(),
          endtDate: (plan['end date'] as Timestamp).toDate(),
          notes: plan['notes']);
    }).toList();
    getAllTripPlanNotifier.value = allPlans;
    notifyListeners();
  }

  // add function
  addTrip(TripPlanModel tripPlanModel,
      List<ModelDestination> destinationIds) async {
    final tripRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .doc();

    await tripRef.set({
      'trip id': tripRef.id,
      'trip name': tripPlanModel.tripName,
      'start date': Timestamp.fromDate(tripPlanModel.startDate),
      'end date': Timestamp.fromDate(tripPlanModel.endtDate),
      'notes': tripPlanModel.notes,
    });

    for (var value in destinationIds) {
      addDestination(value.id!, tripRef.id);
    }
  }

  // delete trip functions
  deleteTrip(String tripId) async {
    final tripRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .doc(tripId);

    final destinationIds = await tripRef.collection('destinationIds').get();
    await Future.forEach(destinationIds.docs,
        (destinationDocs) async => await destinationDocs.reference.delete());
    await tripRef.delete();
  }

  // update trip functions
  updateTrip(TripPlanModel tripPlanModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .doc(tripPlanModel.id)
        .update({
      'id': tripPlanModel.id,
      'trip name': tripPlanModel.tripName,
      'start date': tripPlanModel.startDate,
      'end date': tripPlanModel.endtDate,
      'notes': tripPlanModel.notes
    });
  }

  // addDestiantion
  addDestination(String destinationId, String tripId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .doc(tripId)
        .collection('destinationIds')
        .doc(destinationId)
        .set({'time stamb': FieldValue.serverTimestamp()});
  }

  // remove destiantion
  Future<void> removeDestination(String destinationId, String tripId) async {
    final path = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .doc(tripId);
    await path.collection('destinationIds').doc(destinationId).delete();
  }

  // Function to get and sort trip planner lists by date
  Future<List<TripPlanModel>> getSortedTripPlans() async {
    final tripPlansSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .get();

    final tripPlans = tripPlansSnapshot.docs.map((doc) {
      var data = doc.data();
      return TripPlanModel(
        id: doc.id,
        tripName: data['trip name'],
        startDate: (data['start date'] as Timestamp).toDate(),
        endtDate: (data['end date'] as Timestamp).toDate(),
        notes: data['notes'],
      );
    }).toList();

    // Remove expired trips
    final currentDate = DateTime.now();
    tripPlans.removeWhere((trip) => trip.endtDate.isBefore(currentDate));

    // Sort by date (earliest to latest)
    tripPlans.sort((a, b) => a.startDate.compareTo(b.startDate));

    return tripPlans;
  }

  getTripsByDates() async {
    List<TripPlanModel> sortedTripPlans = await getSortedTripPlans();
    sortedTrips.value = sortedTripPlans;
  }
}

ValueNotifier<List<TripPlanModel>> sortedTrips = ValueNotifier([]);

class TripPlanModel {
  String? id;
  String tripName;
  DateTime startDate;
  DateTime endtDate;
  String? notes;
  TripPlanModel({
    this.id,
    required this.tripName,
    required this.startDate,
    required this.endtDate,
    this.notes,
  });
}
