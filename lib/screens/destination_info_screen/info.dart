import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/firebase/firebase_functions/url.dart';
import 'package:travelmate/favorite/favorite_icon_for.dart';
import 'package:travelmate/widgets/text.dart';
import '../../db/model/model_destination/model_destination.dart';

class ScreenInfoDestination extends StatelessWidget {
  const ScreenInfoDestination(
      {super.key, required this.modelDestination, required this.isPlan});
  final ModelDestination modelDestination;
  final bool isPlan;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            //first half container
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.40,
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 380, // Adjust the height as per your requirement
                    autoPlay: true, // Enable auto play for the carousel
                    enlargeCenterPage:
                        true, // Make the current page larger than others
                    viewportFraction: 1.5),
                items: modelDestination.destinationImageUrls.map((imageUrl) {
                  return Container(
                    width: MediaQuery.of(context).size.width * .95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(imageUrl),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // name district category column
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.013),
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modelDestination.destinationName,
                          style: googleFontStyle(
                              fontsize: 25, fontweight: FontWeight.w600),
                        ),
                        Text(
                          "${modelDestination.destinationDistrict}, ${modelDestination.destinationCategory}",
                          style: googleFontStyle(
                              fontsize: 14, fontweight: FontWeight.w400),
                        )
                      ],
                    ),
                    //favorite
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.055,
                          width: MediaQuery.of(context).size.height * 0.055,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:  Color.fromARGB(185, 170, 165, 165),
                          ),
                          child:
                              IconFavorite(destinationId: modelDestination.id!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // second half container
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.013,
                right: MediaQuery.of(context).size.height * 0.013,
              ),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.47,
                // main column
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Divider(color: Color.fromARGB(255, 66, 66, 66)),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'About',
                          style: googleFontStyle(
                              fontsize: 22, fontweight: FontWeight.w400),
                        ),
                      ),
                      Text(
                        modelDestination.destinationDescription,
                        style: googleFontStyle(
                            fontsize: 19, fontweight: FontWeight.w300),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17)),
                                  backgroundColor: Colors.white,
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * .46,
                                      MediaQuery.of(context).size.height *
                                          0.06),
                                  side: const BorderSide(strokeAlign: 0.01)),
                              child: Text(
                                'Back',
                                style: googleFontStyle(
                                    fontweight: FontWeight.w600,
                                    fontsize:
                                        MediaQuery.of(context).size.height *
                                            0.025),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                createdlaunchUrl(
                                    modelDestination.destinationLocation);
                              },
                              icon: const Icon(Icons.location_on),
                              label: Text(
                                'Get Direction',
                                style: googleFontStyle(
                                    fontsize:
                                        MediaQuery.of(context).size.height *
                                            0.024,
                                    fontweight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17)),
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * .47,
                                      MediaQuery.of(context).size.height *
                                          0.06)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
