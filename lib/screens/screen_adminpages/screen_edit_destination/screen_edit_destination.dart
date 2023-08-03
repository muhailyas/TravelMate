import 'package:flutter/material.dart';
import 'package:travelmate/Db/category_and_district_list/category_list.dart';
import 'package:travelmate/repositories/destination_repository.dart';
import '../../../Db/category_and_district_list/district_list.dart';
import '../../../Widgets/ValidatorFunctions.dart';
import '../../../Widgets/text_form_field.dart';
import '../../../db/model/model_destination/model_destination.dart';
import '../screen_destination_add/screen_add_destination.dart';
import '../screen_destination_add/widgets/drop_down_buttonfield.dart';

class ScreenEditDestination extends StatefulWidget {
  const ScreenEditDestination({
    required this.modelDestination,
    super.key,
  });
  final ModelDestination modelDestination;

  @override
  State<ScreenEditDestination> createState() => _ScreenEditDestinationState();
}

class _ScreenEditDestinationState extends State<ScreenEditDestination> {
  late TextEditingController destinationNameController;

  late TextEditingController locationController;

  late TextEditingController descriptionController;

  late List<String> imageDatasForEdit;

  late String districtModelController = '';
  late String categoryModelController = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    destinationNameController =
        TextEditingController(text: widget.modelDestination.destinationName);
    locationController = TextEditingController(
        text: widget.modelDestination.destinationLocation);
    descriptionController = TextEditingController(
        text: widget.modelDestination.destinationDescription);
    imageDatasForEdit = widget.modelDestination.destinationImageUrls;

    districtModelController = widget.modelDestination.destinationDistrict;
    categoryModelController = widget.modelDestination.destinationCategory;

    List<String> selectedImagesPaths = [];
    selectedImagesPaths
        .addAll(selectedImages.map((file) => file.path).toList());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        DestinationRepository().getfiltered();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(88, 80, 36, 0.432),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DropDownButtonField(
                    hintText: 'Select District',
                    listName: districts,
                    item: true,
                    onChanged: (newValue) {
                      setState(() {
                        districtModelController = newValue;
                      });
                    },
                    districtSelectedValue: districtModelController,
                  ),
                  DropDownButtonField(
                    hintText: 'Select Category',
                    listName: categories,
                    item: false,
                    onChanged: (newValue) {
                      setState(() {
                        districtModelController = newValue;
                      });
                    },
                    categorySelectedValue: categoryModelController,
                  ),
                  // Destination Name
                  TextFormFieldWidget(
                      hintText: 'Place Name',
                      function: isValidName,
                      controller: destinationNameController),
                  //Location
                  TextFormFieldWidget(
                      hintText: 'Location',
                      function: isValidName,
                      controller: locationController),
                  //How To Reach There
                  TextFormFieldWidget(
                      hintText: 'Description',
                      function: isValidName,
                      controller: descriptionController),
                  IconButton(
                      onPressed: () async {
                        // await getImages();
                      },
                      icon: const Icon(Icons.cloud_upload_outlined)),

                      // submit

                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submitValidating(context, widget.modelDestination);
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  submitValidating(context, ModelDestination modelDestination) {
    final name = destinationNameController.text;
    final district = districtModelController;
    final category = categoryModelController;
    final description = descriptionController.text;
    final location = locationController.text;
    
    DestinationRepository destinationRepository = DestinationRepository();
    modelDestination.destinationName = name;
    modelDestination.destinationDistrict = district;
    modelDestination.destinationCategory = category;
    modelDestination.destinationDescription = description;
    modelDestination.destinationLocation = location;
    destinationRepository.updateDestination(modelDestination);
    _formKey.currentState!.reset();
  }
}
