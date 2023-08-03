import 'package:flutter/material.dart';
import 'package:travelmate/db/model/model_destination/model_destination.dart';
import 'package:travelmate/screens/trip_plan/screen_trip_plan.dart';

class IconAddRemove extends StatefulWidget {
  const IconAddRemove({super.key, required this.modelDestination});

  final ModelDestination modelDestination;

  @override
  State<IconAddRemove> createState() => IconAddRemoveState();
}

class IconAddRemoveState extends State<IconAddRemove> {
  @override
  Widget build(BuildContext context) {
    // Inside the function that handles selecting a destination
    void handleDestinationSelection(ModelDestination selectedDestination) {
      // Pass the selected destination back as the result using Navigator.pop
      Navigator.pop(context, selectedDestination);
    }

    final isSelected = selectedDestinationIdsforTripPlanning.value
        .contains(widget.modelDestination);

    return InkWell(
      child: Icon(
        isSelected ? Icons.remove : Icons.add,
        size: 30,
      ),
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedDestinationIdsforTripPlanning.value
                .remove(widget.modelDestination);
          } else {
            selectedDestinationIdsforTripPlanning.value
                .add(widget.modelDestination);
            selectedDestinationIdsforTripPlannings.value
                .add(widget.modelDestination);
            handleDestinationSelection(widget.modelDestination);
          }
        });
      },
    );
  }
}
