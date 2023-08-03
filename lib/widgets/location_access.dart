import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationAccess extends StatefulWidget {
  const LocationAccess({Key? key}) : super(key: key);

  @override
  LocationAccessState createState() => LocationAccessState();
}

class LocationAccessState extends State<LocationAccess> {
  String address = 'searching...';

  @override
  void initState() {
    super.initState();
    _getLocationAndAddress();
  }

  Future<void> _getLocationAndAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        address = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          address = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        address = 'Location permissions are permanently denied.';
      });
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _getAddressFromLatLong(position);
    } catch (e) {
      // print('Error fetching location: $e');
    }
  }

  Future<void> _getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        address =
            '${place.subLocality}, ${place.locality} \n${place.administrativeArea}';
      });
    } catch (e) {
      setState(() {
        address = 'not available.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      address,
      style: const TextStyle(color: Colors.black),
    );
  }
}