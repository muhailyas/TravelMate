import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Db/category_and_district_list/category_list.dart';
import 'package:travelmate/Db/category_and_district_list/district_list.dart';
import 'package:travelmate/favorite/favorite_icon_for.dart';
import 'package:travelmate/repositories/destination_repository.dart';
import 'package:travelmate/Widgets/Text.dart';
import 'package:travelmate/screens/destination_info_screen/info.dart';
import 'package:travelmate/screens/trip_plan/widgets/Icon_add_remove.dart';
import '../../Widgets/list_maker.dart';
import '../../db/model/model_destination/model_destination.dart';
import '../../firebase/firebase_functions/firebase_functions.dart';

class ScreenExplore extends StatelessWidget {
  const ScreenExplore({super.key, this.placeName, required this.isPlan});
  final String? placeName;
  final bool isPlan;

  @override
  Widget build(BuildContext context) {
    DestinationRepository().getfiltered();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Explore"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: const Alignment(-0.91, 0),
              child: Text(
                'Select Categories',
                style:
                    googleFontStyle(fontsize: 15, fontweight: FontWeight.bold),
              )),
          CatogaryListMaker(
            count: categories.length,
            list: categories,
          ),
          const Divider(),
          Align(
              alignment: const Alignment(-0.91, 0),
              child: Text(
                'Select Districts',
                style:
                    googleFontStyle(fontsize: 15, fontweight: FontWeight.bold),
              )),
          CatogaryListMaker(
            count: districts.length,
            list: districts,
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ValueListenableBuilder<List<ModelDestination>>(
                  valueListenable: filteredDestination,
                  builder: (context, List<ModelDestination> list, child) {
                    return list.isEmpty
                        ? Center(
                            child: Image.asset(
                            'assets/images/search resultN.png',
                            fit: BoxFit.cover,
                          ))
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = list[index];
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenInfoDestination(
                                                modelDestination: data,
                                                isPlan: false))),
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            data.destinationImageUrls[0]),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.destinationName,
                                          style: subHeadingTextStyle(
                                              color: Colors.white),
                                        ),
                                        isPlan
                                            ? IconAddRemove(
                                                modelDestination: data)
                                            : Material(
                                                elevation: 5,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: const Color.fromARGB(
                                                    172, 255, 255, 255),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.050,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.050,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconFavorite(
                                                      destinationId: data.id!),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                            itemCount: list.length);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
