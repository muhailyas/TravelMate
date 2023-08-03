import 'package:flutter/material.dart';
import 'package:travelmate/screens/trip_plan/edit_trip.dart';
import 'package:travelmate/screens/trip_plan/screen_trip_plan.dart';
import 'package:travelmate/screens/trip_plan/trip_plan_repository.dart';
import 'package:travelmate/screens/trip_plan/trip_planner_info.dart';
import 'package:travelmate/widgets/text.dart';

class ScreenTripPlans extends StatelessWidget {
  const ScreenTripPlans({super.key});

  @override
  Widget build(BuildContext context) {
    TripPlanRepository().getTripPlans();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(
          Icons.flight_takeoff,
          color: Colors.black,
        ),
        title: Text(
          'My Trip Plans',
          style: googleFontStyle(fontsize: 23, fontweight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ValueListenableBuilder(
            valueListenable: getAllTripPlanNotifier,
            builder: (context, List<TripPlanModel> value, _) {
              if (value.isEmpty) {
                return Center(
                  child: Text(
                    "Let's get started! 🗺️ Add your first trip now! 🌟",
                    style: googleFontStyle(
                        fontweight: FontWeight.w400, fontsize: 17),
                  ),
                );
              } else {
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      crossAxisCount: 2),
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var data = value[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TripPlanInfo(tripInfo: data),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/road trip.avif'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data.tripName,
                                      overflow: TextOverflow.ellipsis,
                                      style: googleFontStyle(
                                        fontweight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuButton(
                                  shadowColor: Colors.black,
                                  color: Colors.white,
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenEditTripPlan(tripInfo: data),
                                      ));
                                      // edit function
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete'),
                                          content: Text(
                                              'Are you sure want to delete ${data.tripName} '),
                                          actions: [
                                            ElevatedButton.icon(
                                              label: const Text('Yes'),
                                              onPressed: () {
                                                TripPlanRepository()
                                                    .deleteTrip(data.id!);
                                                Navigator.pop(context);
                                                TripPlanRepository()
                                                    .getTripPlans();
                                              },
                                              icon: const Icon(
                                                Icons.check,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                  backgroundColor:
                                                      Colors.white),
                                            ),
                                            ElevatedButton.icon(
                                              label: const Text('No'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                  backgroundColor:
                                                      Colors.white),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text('Edit')
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text('Delete')
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ScreenTripPlan(),
          ));
        },
        backgroundColor: const Color.fromARGB(251, 226, 228, 153),
        label: Text(
          'add trip',
          style: googleFontStyle(fontsize: 15, fontweight: FontWeight.w400),
        ),
      ),
    );
  }
}
