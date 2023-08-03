import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/db/model/model_destination/model_destination.dart';
import 'package:travelmate/screens/trip_plan/trip_plan_repository.dart';
import 'package:travelmate/widgets/text.dart';
import '../login_screen/screen_login.dart';

ValueNotifier<List<ModelDestination>> destiantionViewerNotifier =
    ValueNotifier<List<ModelDestination>>([]);

class TripPlanInfo extends StatelessWidget {
  const TripPlanInfo({
    super.key,
    required this.tripInfo,
  });
  final TripPlanModel tripInfo;

  getSelectedDestination(String tripInfoid) async {
    final collectionIds = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('trip plans')
        .doc(tripInfoid)
        .collection('destinationIds')
        .get();

    final destinationIds =
        collectionIds.docs.map((destination) => destination.id).toList();

    final collectionDestinations = await Future.wait(destinationIds.map(
        (destinationId) => FirebaseFirestore.instance
            .collection('destinations')
            .doc(destinationId)
            .get()));

    final destinations = collectionDestinations.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
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
    destiantionViewerNotifier.value = destinations;
  }

  @override
  Widget build(BuildContext context) {
    getSelectedDestination(tripInfo.id!);
    bool isNotesVisible = tripInfo.notes!.isEmpty;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Image.asset(
                  'assets/images/planned image.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  tripInfo.tripName,
                  style: googleFontStyle(
                      fontsize: 25, fontweight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.47,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(183, 39, 215, 228),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              "Start Date: ${DateFormat('dd/MM/yyyy').format(tripInfo.startDate)}",
                              overflow: TextOverflow.ellipsis,
                              style: googleFontStyle(
                                  fontsize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontweight: FontWeight.w500),
                            ),
                          )),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 5,
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(183, 39, 215, 228),
                              borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width * 0.47,
                          child: Center(
                              child: Text(
                            "End Date: ${DateFormat('dd/MM/yyyy').format(tripInfo.endtDate)}",
                            overflow: TextOverflow.ellipsis,
                            style: googleFontStyle(
                                fontsize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontweight: FontWeight.w500),
                          ))),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: !isNotesVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Remarks',
                      style: googleFontStyle(
                          fontsize: 25, fontweight: FontWeight.w500),
                    ),
                  )),
              Visibility(
                visible: !isNotesVisible,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(tripInfo.notes!),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Destiantions',
                  style: googleFontStyle(
                      fontsize: 25, fontweight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                    valueListenable: destiantionViewerNotifier,
                    builder: (context, List<ModelDestination> list, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15),
                          itemBuilder: (context, index) {
                            var data = list[index];
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      data.destinationImageUrls[0],
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 40,
                                    width: 170,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            181, 228, 228, 228),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.destinationName,
                                            style: googleFontStyle(
                                                fontsize: 17,
                                                fontweight: FontWeight.w500),
                                          ),
                                          Text(
                                            "${data.destinationDistrict}, ${data.destinationCategory}",
                                            style: googleFontStyle(
                                                fontsize: 13,
                                                fontweight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
