import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Widgets/text.dart';
import 'package:travelmate/screens/login_screen/screen_login.dart';

class ScreenGetStarted extends StatelessWidget {
  const ScreenGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    'assets/images/pexels-samuel-razonable-16656615.jpg'))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(21.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
                    TypewriterAnimatedText(
                      "It's time to explore kerala",
                      textStyle: googleFontStyle(
                          fontsize: 40,
                          fontweight: FontWeight.bold,
                          color: Colors.white),
                      speed: const Duration(milliseconds: 80),
                    ),
                  ]),
                ),
                Align(
                    alignment: const Alignment(0.1, 0), // x only working
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromRGBO(88, 80, 36, 100),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.height * 0.07,
                            )),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const ScreenLogin(),
                          ));
                        },
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
