import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/favorite/favorite_icon_for.dart';
import 'package:travelmate/firebase/firebase_functions/firebase_functions.dart';
import 'package:travelmate/screens/destination_info_screen/info.dart';
import 'package:travelmate/widgets/text.dart';

class ScreenViewCategory extends StatelessWidget {
  const ScreenViewCategory({Key? key, required this.category})
      : super(key: key);

  final String category;
  @override
  Widget build(BuildContext context) {
    getDestinationsForCategory(category);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(category),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ValueListenableBuilder<List<dynamic>>(
            valueListenable: filteredDestinationByCategory,
            builder: (context, destinations, _) {
              return destinations.isEmpty
                  ? const Text('no category added yet')
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        final data = destinations[index];
                        return GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScreenInfoDestination(
                                modelDestination: data, isPlan: false),
                          )),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        data.destinationImageUrls[0]),
                                    fit: BoxFit.cover)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.destinationName,
                                    style: googleFontStyle(
                                        color: Colors.white,
                                        fontweight: FontWeight.w500),
                                  ),
                                  Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(50),
                                    color: const Color.fromARGB(
                                        172, 255, 255, 255),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.050,
                                      width:
                                          MediaQuery.of(context).size.height *
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
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                      itemCount: destinations.length);
            }),
      ),
    );
  }
}
