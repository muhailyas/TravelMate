import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/db/model/model_destination/model_destination.dart';
import 'package:travelmate/firebase/firebase_functions/firebase_functions.dart';
import 'package:travelmate/repositories/destination_repository.dart';
import 'package:travelmate/screens/Screen_adminpages/screen_edit_destination/screen_edit_destination.dart';
import 'package:travelmate/screens/screen_adminpages/screen_destination_add/screen_add_destination.dart';
import '../../Db/category_and_district_list/category_list.dart';
import '../../Db/category_and_district_list/district_list.dart';
import '../../Widgets/Text.dart';
import '../../Widgets/list_maker.dart';
import '../destination_info_screen/info.dart';
import '../login_screen/screen_login.dart';

List selectedCategoriesA = [];
List selectedDistrictA = [];

class ScreenAdmin extends StatefulWidget {
  const ScreenAdmin({super.key});

  @override
  State<ScreenAdmin> createState() => _ScreenAdminState();
}

class _ScreenAdminState extends State<ScreenAdmin> {
  DestinationRepository destinationRepository = DestinationRepository();

  @override
  void initState() {
    super.initState();
    DestinationRepository().getfiltered();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          selectedDistrictsFB!.clear();
          selectedCategoriesFB!.clear();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Admin',
                style: googleFontStyle(
                    fontsize: MediaQuery.of(context).size.height * .05,
                    color: Colors.white,
                    fontweight: FontWeight.w500),
              ),
              flexibleSpace: Image.asset(
                'assets/images/pexels-samuel-razonable-16656615.jpg',
                fit: BoxFit.cover,
              ),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ScreenAddDestination(),
                  )),
                  child: const Icon(
                    Icons.add,
                    size: 50,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const ScreenLogin(),
                      ),
                      (route) => false),
                  child: const Icon(Icons.logout),
                )
              ],
            ),
            body: Column(
              children: [
                Align(
                    alignment: const Alignment(-0.91, 0),
                    child: Text(
                      'Select Categories',
                      style: googleFontStyle(
                          fontsize: 15, fontweight: FontWeight.bold),
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
                      style: googleFontStyle(
                          fontsize: 15, fontweight: FontWeight.bold),
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
                              ? const Center(child: Text('no data added'))
                              : ListView.separated(
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
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              /////////////////
                                                              ScreenEditDestination(
                                                                  modelDestination:
                                                                      data),
                                                        ));
                                                      },
                                                      child: const Icon(
                                                          Icons.edit)),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        deleteDestinationdata(
                                                            context, data.id!);
                                                      },
                                                      // deleteDestinationdata(
                                                      //     context, data),
                                                      child: const Icon(
                                                          Icons.delete)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                  itemCount: list.length);
                        }),
                  ),
                )
              ],
            )),
      ),
    );
  }

  deleteDestinationdata(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('do you want to delete'),
        actions: [
          IconButton.outlined(
              onPressed: () {
                destinationRepository.deleteDestination(id);
                DestinationRepository().getfiltered();
                Navigator.pop(ctx);
              },
              icon: const Icon(Icons.check)),
          IconButton.outlined(
              onPressed: () {
                Navigator.pop(ctx);
              },
              icon: const Icon(
                Icons.close,
              ))
        ],
      ),
    );
  }
}
