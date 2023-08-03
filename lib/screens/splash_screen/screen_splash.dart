// ignore_for_file: use_build_context_synchronously
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/repositories/destination_repository.dart';
import 'package:travelmate/screens/getstarted_screen/screen_setstarted.dart';
import '../../Widgets/appname.dart';
import '../bottombar_screen/bottom_navigation_bar.dart';
import '../network_check_screen/network_check_screen.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key, required this.login});
  final bool login;
  checkLogin(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NetworkCheckingScreen(login: login),
          ));
    }
    if (login) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNavigationBarOwn(),
      ));
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ScreenGetStarted(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    DestinationRepository().getAllDatas();
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image:
              AssetImage('assets/images/pexels-samuel-razonable-16656615.jpg'),
          fit: BoxFit.cover,
        )),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: FadeTextAnimation(),
        ),
      ),
    );
  }
}
