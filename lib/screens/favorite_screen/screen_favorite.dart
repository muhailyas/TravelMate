import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/screens/login_screen/screen_login.dart';
import '../../Widgets/Text.dart';
import '../../db/model/model_destination/model_destination.dart';
import '../../favorite/favorite_icon_for.dart';
import '../../favorite/favorite_model.dart';
import '../destination_info_screen/info.dart';

class ScreenFavorite extends StatefulWidget {
  const ScreenFavorite({super.key});

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
  bool showProgressIndicator = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showProgressIndicator = !showProgressIndicator;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteModel = Provider.of<FavoriteModel>(context);
    favoriteModel.initFavorites(currentUserId);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text('Favorites'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: showProgressIndicator
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ValueListenableBuilder<List<ModelDestination>>(
                  valueListenable: favoriteModel.favoritesListenable,
                  builder: (context, List<ModelDestination> list, child) {
                    return list.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: double.infinity),
                              Text(
                                'No favorites added yet?',
                                style: googleFontStyle(
                                    fontsize: 23, fontweight: FontWeight.w700),
                              ),
                              Text(
                                'Your favorites list is waiting to be filled!',
                                style: googleFontStyle(
                                    fontsize: 17, fontweight: FontWeight.w300),
                              )
                            ],
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = list[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ScreenInfoDestination(
                                        modelDestination: data, isPlan: false),
                                  ));
                                },
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        data.destinationImageUrls[0],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data.destinationName,
                                            style: subHeadingTextStyle(
                                                color: Colors.white),
                                          ),
                                          Material(
                                            elevation: 5,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: const Color.fromARGB(
                                                172, 255, 255, 255),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.050,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
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
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            itemCount: list.length,
                          );
                  },
                ),
        ),
      ),
    );
  }
}
