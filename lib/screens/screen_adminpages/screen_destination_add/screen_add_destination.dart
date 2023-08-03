import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/Db/category_and_district_list/category_list.dart';
import 'package:travelmate/Db/category_and_district_list/district_list.dart';
import 'package:travelmate/db/model/model_destination/model_destination.dart';
import 'package:travelmate/repositories/destination_repository.dart';
import 'package:travelmate/screens/Screen_adminpages/screen_destination_add/widgets/drop_down_buttonfield.dart';
import 'package:travelmate/Widgets/text.dart';
import 'package:travelmate/Widgets/text_form_field.dart';
import 'package:travelmate/Widgets/validatorfunctions.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

List<String> selectedImagesPaths = [];

List<String> imageUrls = [];

class ScreenAddDestination extends StatefulWidget {
  const ScreenAddDestination({super.key});

  @override
  State<ScreenAddDestination> createState() => ScreenAddDestinationState();
}

List<File> selectedImages = [];
final picker = ImagePicker();

class ScreenAddDestinationState extends State<ScreenAddDestination> {
  bool isLoading = false;
  bool isValueHere = false;
  bool start = false;

  final destinationNameController = TextEditingController();

  final locationController = TextEditingController();

  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late String districtModelController = '';

  late String categoryModelController = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedImages.clear();
        DestinationRepository().getAllDatas();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 102, 93, 42),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 102, 93, 42),
          elevation: 0,
          foregroundColor: Colors.white,
          title: Text(
            'Add Destination',
            style: googleFontStyle(
                fontweight: FontWeight.bold, fontsize: 22, color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                // District
                DropDownButtonField(
                  hintText: 'Select district',
                  listName: districts,
                  item: true,
                  onChanged: (newValue) {
                    setState(() {
                      districtModelController = newValue;
                    });
                  },
                ),

                // Category
                DropDownButtonField(
                  hintText: 'Select category',
                  listName: categories,
                  item: false,
                  onChanged: (newValue) {
                    setState(() {
                      categoryModelController = newValue;
                    });
                  },
                ),

                // Destination Name
                TextFormFieldWidget(
                    hintText: 'Place Name',
                    function: isValidName,
                    controller: destinationNameController),
                //Location
                TextFormFieldWidget(
                    hintText: 'Location',
                    function: isValidNames,
                    controller: locationController),
                TextFormFieldWidget(
                    hintText: 'Description',
                    function: isValidNames,
                    controller: descriptionController),
                isLoading
                    ? Container()
                    : TextButton.icon(
                        onPressed: () async {
                          await imagePicker();
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload Images'),
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                      ),
                Container(
                  width: double.infinity,
                ),
                Visibility(
                  visible: selectedImages.isNotEmpty,
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 09,
                      ),
                      itemCount: selectedImages.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool firstPadded = index == 0;
                        bool lastPadded = index == selectedImages.length - 1;
                        return Padding(
                          padding: firstPadded
                              ? const EdgeInsets.only(left: 30)
                              : lastPadded
                                  ? const EdgeInsets.only(right: 30)
                                  : EdgeInsets.zero,
                          child: Container(
                            height: 80,
                            width: 90,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(selectedImages[index]),
                                  fit: BoxFit.cover),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImages
                                        .remove(selectedImages[index]);
                                  });
                                },
                                child: const Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white,
                                    ))),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitValidating();
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Submit'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submitValidating() async {
    final destinationName = destinationNameController.text;
    final destinationLocation = locationController.text;
    final description = descriptionController.text;
    if (destinationName.isEmpty ||
            destinationLocation.isEmpty ||
            description.isEmpty
        // || selectedImages.isEmpty
        ) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('please complete full')));
      return;
    } else {
      setState(() {
        isLoading = true;
      });
      await starter(destinationName);
      DestinationRepository destinationRepository = DestinationRepository();
      ModelDestination modelDestination = ModelDestination(
          destinationName: destinationName,
          destinationDistrict: districtModelController,
          destinationCategory: categoryModelController,
          destinationLocation: destinationLocation,
          destinationDescription: description,
          destinationImageUrls: imageUrls);
      destinationRepository.addDestination(modelDestination: modelDestination);
    }
    setState(() {
      destinationNameController.clear();
      districtModelController = '';
      categoryModelController = '';
      locationController.clear();
      descriptionController.clear();
      imageUrls.clear();
      isLoading = false;
    });
  }

  Future<List<String>?> pickImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      return pickedFiles.map((file) => file.path).toList();
    }

    return null;
  }

  List<String>? imagePaths;
  imagePicker() async {
    imagePaths = await pickImages();
    if (imagePaths!.isNotEmpty) {
      setState(() {
        selectedImages
            .addAll(imagePaths!.map((pickedFile) => File(pickedFile)));
      });
    }
  }

  starter(destinationName) async {
    if (imagePaths != null && imagePaths!.isNotEmpty) {
      for (String imagePath in imagePaths!) {
        String imageUrl = await uploadImageToFirebase(
            imagePath: imagePath, destinationName: destinationName);
        imageUrls.add(imageUrl);
      }
    }
  }

  Future<String> uploadImageToFirebase({
    required String imagePath,
    required String destinationName,
  }) async {
    String fileName = imagePath.split('/').last;
    String folderName = 'destination images';

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child(destinationName)
        .child(fileName);

    try {
      await ref.putFile(File(imagePath));
    } catch (error) {
      return error.toString();
    }
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }
}
