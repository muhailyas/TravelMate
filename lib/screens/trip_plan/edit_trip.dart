import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelmate/screens/explore_screen/screen_explore.dart';
import 'package:travelmate/screens/trip_plan/trip_plan_repository.dart';
import '../../Widgets/Text.dart';
import '../../db/model/model_destination/model_destination.dart';
import '../login_screen/screen_login.dart';

class ScreenEditTripPlan extends StatefulWidget {
  const ScreenEditTripPlan({
    Key? key,
    required this.tripInfo,
  }) : super(key: key);

  final TripPlanModel tripInfo;

  @override
  State<ScreenEditTripPlan> createState() => _ScreenEditTripPlanState();
}

class _ScreenEditTripPlanState extends State<ScreenEditTripPlan> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController tripNameController;
  late TextEditingController remarksController;

  final Map<String, ModelDestination> selectedDestinationsMap = {};

  @override
  void initState() {
    super.initState();
    tripNameController = TextEditingController(text: widget.tripInfo.tripName);
    remarksController = TextEditingController(text: widget.tripInfo.notes);
    getSelectedDestination(widget.tripInfo.id!);
  }

  void getSelectedDestination(String tripInfoid) async {
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

    setState(() {
      // Clear the existing selected destinations and add the fetched ones
      selectedDestinationsMap.clear();
      for (var destination in destinations) {
        selectedDestinationsMap[destination.id!] = destination;
      }
    });
  }

  void updateTripName(String newTripName) {
    widget.tripInfo.tripName = newTripName;
    TripPlanRepository().updateTrip(widget.tripInfo);
    setState(() {});
  }

  void updateNotes(String newNotes) {
    widget.tripInfo.notes = newNotes;
    TripPlanRepository().updateTrip(widget.tripInfo);
    setState(() {});
  }

  void deleteDestination(String destinationId, String tripId) async {
    await TripPlanRepository().removeDestination(destinationId, tripId);
    setState(() {
      selectedDestinationsMap.remove(destinationId);
    });
  }

  void addDestination(ModelDestination newDestination) {
    if (!selectedDestinationsMap.containsKey(newDestination.id)) {
      TripPlanRepository()
          .addDestination(newDestination.id!, widget.tripInfo.id!);
      setState(() {
        selectedDestinationsMap[newDestination.id!] = newDestination;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNotesVisible = widget.tripInfo.notes!.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image for the trip plan
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Image.asset(
                  'assets/images/planned image.jpeg',
                  fit: BoxFit.cover,
                ),
              ),

              // Trip name with edit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.tripInfo.tripName,
                        style: googleFontStyle(
                            fontsize: 25, fontweight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Show dialog to edit trip name
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              Form(
                                key: formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Trip name is required';
                                    }
                                    return null;
                                  },
                                  controller: tripNameController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.edit),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              // Update trip name button
                              TextButton.icon(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    updateTripName(tripNameController.text);
                                    Navigator.pop(context);
                                  }
                                },
                                icon: const Icon(
                                    Icons.security_update_good_rounded),
                                label: const Text('Update'),
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),

              // Start and End date of the trip
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Start Date
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.47,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(183, 39, 215, 228),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Start Date: ${DateFormat('dd/MM/yyyy').format(widget.tripInfo.startDate)}",
                            overflow: TextOverflow.ellipsis,
                            style: googleFontStyle(
                              fontsize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // End Date
                    Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 5,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(183, 39, 215, 228),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: Center(
                          child: Text(
                            "End Date: ${DateFormat('dd/MM/yyyy').format(widget.tripInfo.endtDate)}",
                            overflow: TextOverflow.ellipsis,
                            style: googleFontStyle(
                              fontsize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Remarks section
              Visibility(
                visible: !isNotesVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Remarks',
                        style: googleFontStyle(
                            fontsize: 25, fontweight: FontWeight.w500),
                      ),
                      IconButton(
                        onPressed: () {
                          // Show dialog to edit remarks
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller: remarksController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.edit),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      updateNotes(remarksController.text);
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: const Icon(Icons.security_update_good),
                                  label: const Text('Update'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),

              // Display remarks
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.tripInfo.notes!),
                      ),
                    ),
                  ),
                ),
              ),

              // Destinations section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Destinations',
                      style: googleFontStyle(
                          fontsize: 25, fontweight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          label: const Text(
                            'Add',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            // Navigate to ScreenExplore and wait for the result
                            final selectedDestination =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenExplore(isPlan: true),
                              ),
                            );

                            // If a destination is selected, add it to the list
                            if (selectedDestination != null) {
                              addDestination(
                                  selectedDestination as ModelDestination);
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Grid view of destinations
              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: ValueNotifier<List<ModelDestination>>(
                      selectedDestinationsMap.values.toList()),
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
                          crossAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          var data = list[index];
                          return GridTile(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  bool isSelected =
                                      selectedDestinationsMap.containsKey(
                                          data.id);
                                  if (isSelected) {
                                    deleteDestination(
                                        data.id!, widget.tripInfo.id!);
                                  } else {
                                    addDestination(data);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      data.destinationImageUrls[0],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: IconButton(
                                          onPressed: () {
                                            deleteDestination(
                                                data.id!, widget.tripInfo.id!);
                                          },
                                          icon: const Icon(
                                            Icons.delete_sweep,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.085,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height: 40,
                                        width: 170,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            181,
                                            228,
                                            228,
                                            228,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.destinationName,
                                                style: googleFontStyle(
                                                    fontsize: 17,
                                                    fontweight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                "${data.destinationDistrict}, ${data.destinationCategory}",
                                                style: googleFontStyle(
                                                  fontsize: 13,
                                                  fontweight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
