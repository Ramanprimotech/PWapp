import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/utility/Utility.dart';

class GetGeoLocation {
  String? currentAddress;
  Position? _currentPosition;
  String? currentZipcode;

  Future<Position> position =
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Utility().toast(context!,
          'Location services are disabled. Please enable the services');

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Utility().toast(context!, 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Utility().toast(context!,
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  Future<String?> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      currentZipcode = "${place.postalCode}";
      debugPrint("address: ${currentZipcode ?? " "}");
    }).catchError((e) {
      debugPrint(e);
    });
    return currentZipcode;
  }

  Future<Position?> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return null;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (Position position) {
        _currentPosition = position;

        debugPrint("LAT: ${_currentPosition?.latitude ?? " "}");
        debugPrint("Long: ${_currentPosition?.longitude ?? " "}");
      },
    ).catchError((e) {
      debugPrint(e);
    });
    return _currentPosition;
    // return getAddressFromLatLng(_currentPosition!);
  }
}
