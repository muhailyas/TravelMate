import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Db/category_and_district_list/category_list.dart';
import 'package:travelmate/Widgets/Text.dart';
import 'package:travelmate/Widgets/customtext.dart';
import 'package:travelmate/db/model/model_destination/model_destination.dart';
import 'package:travelmate/favorite/favorite_icon_for.dart';
import 'package:travelmate/firebase/firebase_functions/firebase_functions.dart';
import 'package:travelmate/screens/destination_info_screen/info.dart';
import 'package:travelmate/screens/login_screen/screen_login.dart';
import 'package:travelmate/screens/popular_category_list_screen/screen_listview_category.dart';
import 'package:travelmate/screens/trip_plan/trip_plan_repository.dart';
import 'package:travelmate/screens/trip_plan/trip_planner_info.dart';
import 'package:travelmate/widgets/colors.dart';
import 'package:travelmate/widgets/location_access.dart';
import '../../Widgets/slide_drawer.dart';
import '../../favorite/favorite_model.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  bool isVisible = false;
  late dynamic size, heightmedia, widthmedia;

  @override
  void initState() {
    super.initState();
    final favoriteModel = Provider.of<FavoriteModel>(context, listen: false);
    favoriteModel.initFavorites(currentUserId);
    fechTripPlans();
  }

  fechTripPlans() async {
    await TripPlanRepository().getTripsByDates();
    setState(() {
      isVisible = sortedTrips.value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> containerIndexes = List.generate(5, (index) => index);
    size = MediaQuery.of(context).size;
    heightmedia = size.height;
    widthmedia = size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          titleSpacing: 5,
          actions: const [
            SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
                  LocationAccess(),
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
          elevation: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 30,
              ),
            );
          }),
          title: Text(
            'DISCOVERY',
            style: googleFontStyle(fontsize: 25, fontweight: FontWeight.bold),
          ),
          backgroundColor: backGroundColor,
        ),
        drawer: const SlideDrawer(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widthmedia * 0.03, vertical: 5),
                child: Visibility(
                  visible: isVisible,
                  child: Text('Upcoming Trips',
                      style: googleFontStyle(
                          color: Colors.black,
                          fontsize: MediaQuery.of(context).size.height * 0.023,
                          fontweight: FontWeight.w500)),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: SizedBox(
                  height: heightmedia * 0.13,
                  width: double.infinity,
                  child: ValueListenableBuilder(
                      valueListenable: sortedTrips,
                      builder: (context, List<TripPlanModel> list, child) {
                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 5,
                                ),
                            itemCount: list.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = list[index];
                              return InkWell(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      TripPlanInfo(tripInfo: data),
                                )),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 10 : 0,
                                      right: list.length - 1 == index ? 10 : 0),
                                  child: SizedBox(
                                    width: widthmedia * 0.20,
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: widthmedia * 0.095,
                                          backgroundImage: const AssetImage(
                                              'assets/images/road trip.avif'),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: heightmedia * 0.02,
                                            width: widthmedia * 0.4,
                                            child: OverflowBox(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                data.tripName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ),
              ),
              //Highlights...
              Padding(
                padding: EdgeInsets.only(
                    left: widthmedia * 0.03,
                    right: widthmedia * 0.03,
                    bottom: heightmedia * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Highlights',
                      style: googleFontStyle(
                          fontsize: 23, fontweight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: heightmedia * 0.25,
                width: double.infinity,
                child: ValueListenableBuilder<List<ModelDestination>>(
                  valueListenable: allDestinations,
                  builder: (context, List<ModelDestination> list, child) {
                    if (list.isEmpty || list.length < 5) {
                      return const CircularProgressIndicator();
                    } else {
                      return CarouselSlider(
                        items: containerIndexes.map((index) {
                          var data = list[index];
                          return InkWell(
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ScreenInfoDestination(
                                modelDestination: data,
                                isPlan: false,
                              );
                            })),
                            child: Container(
                              width: widthmedia * 0.95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      data.destinationImageUrls[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: data.destinationName,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(50),
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
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconFavorite(
                                            destinationId: data.id!,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 10),
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: heightmedia * 0.01,
                    horizontal: widthmedia * 0.03),
                child: Text(
                  "Popular Categories",
                  style: googleFontStyle(
                      fontsize: 23, fontweight: FontWeight.w500),
                ),
              ),
              // popular categories
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthmedia * 0.029),
                child: SizedBox(
                  width: double.infinity,
                  child: GridView.builder(
                    itemCount: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScreenViewCategory(
                              category: categories[index][0],
                            ),
                          ));
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            image: DecorationImage(
                              image: AssetImage(categories[index][1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                categories[index][0],
                                style: subHeadingTextStyle(
                                  color: Colors.white,
                                  fontsize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              //Where to go right now
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 12),
                child: Text(
                  'Where to go right now',
                  style: googleFontStyle(
                      fontsize: 23, fontweight: FontWeight.w500),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 10),
                child: Text("Spots at the top of traveler's must-go lists"),
              ),
              SizedBox(
                child: Visibility(
                  visible: allDestinations.value.isNotEmpty,
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.24,
                    child: ValueListenableBuilder<List<ModelDestination>>(
                        valueListenable: allDestinations,
                        builder: (contextcontext, List<ModelDestination> list,
                            child) {
                          return ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var data = list[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 12 : 0,
                                  right: index == 5 ? 12 : 0,
                                ),
                                child: InkWell(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => ScreenInfoDestination(
                                        modelDestination: data, isPlan: false),
                                  )),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            data.destinationImageUrls[0]),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          width: double.infinity,
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: const Alignment(.8, 0),
                                          child: Material(
                                            elevation: 5,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: const Color.fromARGB(
                                                172, 255, 255, 255),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.040,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.040,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconFavorite(
                                                destinationId: data.id!,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.11,
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.059,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.42,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  181, 228, 228, 228),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  data.destinationName,
                                                  style: googleFontStyle(
                                                      fontsize: 16,
                                                      fontweight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    data.destinationDistrict,
                                                    style: googleFontStyle(
                                                        fontsize: 13,
                                                        fontweight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.03),
                            itemCount: 6,
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    setState(() {
      isVisible = !isVisible;
    });
  }
}
