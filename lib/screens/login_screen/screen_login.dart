// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:travelmate/Widgets/Text.dart';
import 'package:travelmate/firebase/firebase_functions/firebase_functions.dart';
import 'package:travelmate/screens/screen_adminpages/screen_admin.dart';
import 'package:travelmate/screens/signup_screen/screen_signup.dart';
import '../../Widgets/text_form_field.dart';
import '../../Widgets/ValidatorFunctions.dart';
import '../../widgets/snakbar_widget.dart';
import '../bottombar_screen/bottom_navigation_bar.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});
  
  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size;
    final double heightmedia;
    final double widthmedia;
    size = MediaQuery.of(context).size;
    heightmedia = size.height;
    widthmedia = size.width;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
                'assets/images/pexels-samuel-razonable-16656615.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.exclusion),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: const Alignment(0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Join Us",
                  style: googleFontStyle(
                      color: Colors.white,
                      fontsize: 40,
                      fontweight: FontWeight.w600),
                ),
                Container(
                  height: heightmedia * 0.380,
                  width: widthmedia * 0.97,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(88, 80, 36, 0.432),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: heightmedia * 0.02,
                        ),
                        TextFormFieldWidget(
                          hintText: 'email',
                          function: isValidEmail,
                          controller: emailController,
                        ),
                        TextFormFieldWidget(
                          hintText: 'password',
                          function: isValidPass,
                          controller: passController,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await validate(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromRGBO(88, 80, 36, 90),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.85,
                              MediaQuery.of(context).size.height * 0.07,
                            ),
                          ),
                          child: Text(
                            'login',
                            style: subHeadingTextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ScreenSignUp(),
                              ));
                            },
                            child: RichText(
                                text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: 'Don\'t have an account?',
                              ),
                              TextSpan(
                                  text: ' SignUp',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 174, 255)))
                            ])))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validate(BuildContext context) async {
    final email = emailController.text;
    final password = passController.text;
    showDialog(
      context: context,
      builder: (context) {
        return const RiveAnimation.asset('assets/images/loading animation.riv');
      },
    );
    int returnValue = await AuthFunctinos.signIn(email, password, context);
    Navigator.pop(context);

    if (returnValue == 0) {
      showCustomSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: 'Check your internet connection',
        icon: const Icon(Icons.error),
      );
    } else if (returnValue == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarOwn(),
        ),
      );
      showCustomSnackbar(
        context: context,
        backgroundColor: Colors.green,
        message: 'Successfully logged in',
        icon: const Icon(Icons.check),
      );
    } else if (returnValue == 2) {
      showCustomSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: 'User not found',
        icon: const Icon(Icons.error),
      );
    } else if (returnValue == 3) {
      showCustomSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: 'Wrong password',
        icon: const Icon(Icons.error),
      );
    } else if (returnValue == 11) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ScreenAdmin(),
      ));
    } else {
      showCustomSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: 'Something went wrong',
        icon: const Icon(Icons.error),
      );
    }
  }
}

String currentUserId = FirebaseAuth.instance.currentUser!.uid;
