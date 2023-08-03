// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:travelmate/screens/getstarted_screen/screen_setstarted.dart';
import 'package:travelmate/widgets/text.dart';

import '../bottombar_screen/bottom_navigation_bar.dart';

class NetworkCheckingScreen extends StatelessWidget {
  const NetworkCheckingScreen({super.key, required this.login});
  final bool login;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/pexels-samuel-razonable-16656615.jpg'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                Text(
                  "Network Error",
                  style: googleFontStyle(
                      fontweight: FontWeight.w500,
                      color: Colors.white,
                      fontsize: 23),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const RiveAnimation.asset(
                              'assets/images/loading animation.riv');
                        },
                      );
                      await Future.delayed(const Duration(seconds: 1));
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("No Internet Connection"),
                          content: const Text(
                              "Please check your internet connection and try again."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const RiveAnimation.asset(
                              'assets/images/loading animation.riv');
                        },
                      );
                      await Future.delayed(const Duration(seconds: 1));
                      if (login) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const BottomNavigationBarOwn(),
                        ));
                      } else {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ScreenGetStarted(),
                        ));
                      }
                    }
                  },
                  label: const Text('refresh'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                )
              ],
            ),
          )),
    );
  }
}
