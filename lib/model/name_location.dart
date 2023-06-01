// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/exception_handler.dart';
import '../pages/connection.dart';

class LocationModel {
  String nameLocation;
  String place;
  double perangkatLatitude;
  double perangkatLongitude;

  LocationModel({
    required this.nameLocation,
    required this.place,
    required this.perangkatLatitude,
    required this.perangkatLongitude,
  });
}

class LocationRepository {
  static Future<LocationModel> getLocation(BuildContext context) async {
    String? nameLocation;
    String? place;
    double? perangkatLatitude;
    double? perangkatLongitude;
    try {
      var currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placeName = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      perangkatLatitude = currentPosition.latitude;
      perangkatLongitude = currentPosition.longitude;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userLatitude', perangkatLatitude.toString());
      await prefs.setString('userLongitude', perangkatLongitude.toString());
      print(
          'LatLng perangkat : ${currentPosition.latitude}, ${currentPosition.longitude}');
      nameLocation =
          '${placeName[0].subLocality!}, ${placeName[0].locality!}, ${placeName[0].subAdministrativeArea!}, ${placeName[0].administrativeArea!}, ${placeName[0].country!}, ${placeName[0].postalCode!}';
      print('lokasi perangkat : $nameLocation');
      await prefs.setString('userLocation', nameLocation);
      place = placeName[0].street;
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
          
        ),
        (route) => false,
      );
    }
    return LocationModel(
      nameLocation: nameLocation!,
      place: place!,
      perangkatLatitude: perangkatLatitude!,
      perangkatLongitude: perangkatLongitude!,
    );
  }
}
