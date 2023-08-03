import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/widgets/highlight_text.dart';
import '../../db/model/model_destination/model_destination.dart';
import '../destination_info_screen/info.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({Key? key}) : super(key: key);

  @override
  ScreenSearchState createState() => ScreenSearchState();
}

class ScreenSearchState extends State<ScreenSearch> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearchEmpty = searchController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search destinations',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                    if (!isSearchEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('destinations')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error occurred.'),
                    );
                  } else {
                    final destinations = snapshot.data!.docs
                        .map((doc) => ModelDestination(
                              id: doc.id,
                              destinationName: doc['name'],
                              destinationDistrict: doc['district'],
                              destinationCategory: doc['category'],
                              destinationLocation: doc['location'],
                              destinationDescription: doc['description'],
                              destinationImageUrls:
                                  List<String>.from(doc['ImageUrls']),
                            ))
                        .where((destination) => destination.destinationName
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();

                    if (destinations.isEmpty) {
                      return Center(
                        child: Image.asset(
                          'assets/images/search resultN.png',
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final destination = destinations[index];
                        return ListTile(
                          title: HighlightText(
                            searchQuery: searchController.text,
                            fullText: destination.destinationName,
                          ),
                          subtitle: Text(destination.destinationDistrict),
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                destination.destinationImageUrls[0]),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScreenInfoDestination(
                                  modelDestination: destination,
                                  isPlan: false,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
