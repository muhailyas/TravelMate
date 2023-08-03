import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:travelmate/firebase/firebase_functions/firebase_functions.dart';
import 'package:travelmate/widgets/snakbar_widget.dart';
import '../../Widgets/Text.dart';
import '../../Widgets/ValidatorFunctions.dart';
import '../../Widgets/text_form_field.dart';
import 'package:travelmate/screens/login_screen/screen_login.dart';

class ScreenSignUp extends StatelessWidget {
  ScreenSignUp({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    dynamic size, heightmedia, widthmedia;
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
                  height: heightmedia * 0.459,
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
                          hintText: 'name',
                          function: isValidName,
                          controller: nameController,
                        ),
                        TextFormFieldWidget(
                          hintText: 'email',
                          function: isValidEmail,
                          controller: emailController,
                        ),
                        TextFormFieldWidget(
                          // obscureText: true,
                          hintText: 'password',
                          function: isValidPass,
                          controller: passController,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              validate(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            backgroundColor:
                                const Color.fromRGBO(88, 80, 36, 90),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.height * 0.07,
                            ),
                          ),
                          child: Text(
                            'SignUp',
                            style: subHeadingTextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ScreenLogin(),
                              ));
                            },
                            child: RichText(
                                text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: 'Already have an account?',
                              ),
                              TextSpan(
                                  text: 'Login',
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

  validate(context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passController.text.trim();
    showDialog(
      context: context,
      builder: (context) {
        return const RiveAnimation.asset('assets/images/loading animation.riv');
      },
    );
    int authResult =
        await AuthFunctinos.signupUser(name, email, password, context);
    if (authResult == 1) {
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ScreenLogin(),
      ));
      showCustomSnackbar(
          context: context,
          backgroundColor: Colors.green,
          message: 'User Registered Successfully',
          icon: const Icon(Icons.check_circle));
    } else if (authResult == 2) {
      Navigator.pop(context);
      // weak password
      showCustomSnackbar(
          context: context,
          backgroundColor: Colors.red,
          message: 'Password Provided is too weak',
          icon: const Icon(Icons.password));
    } else if (authResult == 3) {
      Navigator.pop(context);
      //email already exist
      showCustomSnackbar(
          second: 4,
          backgroundColor: Colors.red,
          context: context,
          message: 'Email Provided already Exists',
          icon: const Icon(
            Icons.email_outlined,
          ));
    } else if (authResult == 4) {
      Navigator.pop(context);
      //something error
      showCustomSnackbar(
          context: context,
          backgroundColor: Colors.red,
          message: 'Something went wrong',
          icon: const Icon(Icons.adb_outlined));
    }
  }
}
