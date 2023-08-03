import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/favorite/favorite_model.dart';
import 'package:travelmate/screens/explore_screen/screen_explore.dart';
import 'package:travelmate/screens/search_screen/screen_search.dart';
import 'package:travelmate/screens/trip_plan/screen_trip_plan.dart';
import 'package:travelmate/screens/trip_plan/screen_trip_plans_list.dart';
import 'package:travelmate/screens/trip_plan/trip_plan_repository.dart';

import '../../repositories/destination_repository.dart';
import '../favorite_screen/screen_favorite.dart';
import '../home_screen/screen_home.dart';
import '../login_screen/screen_login.dart';

class BottomNavigationBarOwn extends StatefulWidget {
  const BottomNavigationBarOwn({super.key});
  @override
  State<BottomNavigationBarOwn> createState() => _BottomNavigationBarOwnState();
}

class _BottomNavigationBarOwnState extends State<BottomNavigationBarOwn> {
  @override
  void initState() {
    super.initState();
    final favoriteModel = Provider.of<FavoriteModel>(context, listen: false);
    favoriteModel.initFavorites(currentUserId);
    TripPlanRepository().getTripPlans();
  }

  int currentIndex = 0;
  List currentLists = const [
    ScreenHome(),
    ScreenExplore(isPlan: false),
    ScreenSearch(),
    ScreenTripPlans(),
    ScreenFavorite()
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedCategoriesFB!.clear();
        selectedDistrictsFB!.clear();
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: FlashyTabBar(
          selectedIndex: currentIndex,
          items: [
            FlashyTabBarItem(
                icon: const Icon(Icons.home_rounded),
                title: const Text('Home')),
            FlashyTabBarItem(
                icon: const Icon(Icons.explore), title: const Text('Explore')),
            FlashyTabBarItem(
                icon: const Icon(Icons.search), title: const Text('Search')),
            FlashyTabBarItem(
                icon: const Icon(Icons.flight_takeoff),
                title: const Text('Trip plan')),
            FlashyTabBarItem(
                icon: const Icon(Icons.favorite_border_outlined),
                title: const Text('Favorites')),
          ],
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            if (currentIndex == 3) {
              TripPlanRepository().getTripPlans();
            }
            selectedDestinationIdsforTripPlanning.value.clear();
            selectedCategoriesFB!.clear();
            selectedDistrictsFB!.clear();
          }),
        ),
        body: currentLists[currentIndex],
      ),
    );
  }
}
