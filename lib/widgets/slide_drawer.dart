// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/screens/Screen_adminpages/screen_admin.dart';
import 'package:travelmate/firebase/firebase_functions/firebase_functions.dart';
import 'package:travelmate/screens/about/screen_about.dart';
import 'package:travelmate/screens/login_screen/screen_login.dart';
import 'package:travelmate/widgets/text.dart';

class SlideDrawer extends StatefulWidget {
  const SlideDrawer({Key? key}) : super(key: key);

  @override
  State<SlideDrawer> createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController updateNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    return Drawer(
      width: MediaQuery.of(context).size.width * .6,
      child: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/pexels-samuel-razonable-16656615.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.170,
            child: StreamBuilder<DocumentSnapshot>(
              stream: userDocRef.snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  if (data != null) {
                    String name = data['name'];
                    String email = data['email'];
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                            ),
                            Text(
                              name,
                              style: googleFontStyle(
                                fontweight: FontWeight.w600,
                                fontsize: 25,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              email,
                              style: googleFontStyle(
                                fontweight: FontWeight.w400,
                                fontsize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit name"),
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: userDocRef.snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasData && snapshot.data!.exists) {
                        Map<String, dynamic>? data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        if (data != null) {
                          String name = data['name'];
                          updateNameController.text = name; // Set initial value
                        }
                      }
                      return AlertDialog(
                        title: Text(
                          'Edit name',
                          style: googleFontStyle(fontweight: FontWeight.w500),
                        ),
                        actions: [
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: updateNameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black),
                                child: Text(
                                  'Cancel',
                                  style: googleFontStyle(
                                      fontsize: 16,
                                      fontweight: FontWeight.w400),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    String updatedName =
                                        updateNameController.text;
                                    if (updateNameInFirestore(updatedName)) {
                                      showSnackbar(context, true);
                                    } else {
                                      showSnackbar(context, false);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black),
                                child: Text(
                                  'Update',
                                  style: googleFontStyle(
                                      fontsize: 16,
                                      fontweight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.ios_share_rounded),
            title: const Text("Share"),
            onLongPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ScreenAdmin(),
              ),
            ),
            // onTap: () => Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => 
            // )),
          ),
          /*==============About===============*/
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ScreenAbout(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('LogOut'),
                        content: const Text('Are you sure want to Logout'),
                        actions: [
                          TextButton.icon(
                              onPressed: () async {
                                int result =
                                    await AuthFunctinos.signoutUser(context);
                                if (result == 0) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content:
                                        Text('Check your internet connection'),
                                  ));
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenLogin(),
                                      ),
                                      (route) => false);
                                }
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Yes')),
                          TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                              label: const Text('No')),
                        ],
                      ));
            },
          ),
        ],
      ),
    );
  }

  bool updateNameInFirestore(String updatedName) {
    final user = FirebaseAuth.instance.currentUser;
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    userDocRef.update({'name': updatedName}).then((_) {
      return true;
    }).catchError((error) {
      return false;
    });
    return true;
  }

  void showSnackbar(BuildContext context, bool value) {
    SnackBar snackBar;
    if (value) {
      snackBar = const SnackBar(content: Text('Name updated successfully'));
    } else {
      snackBar = const SnackBar(content: Text('Something went wrong'));
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
