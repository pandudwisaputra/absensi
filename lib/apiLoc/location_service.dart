import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:trust_location/trust_location.dart';

class LocationUpdater {
  Location location = Location();
  StreamController<bool> locationStreamController =
      StreamController<bool>.broadcast();

  double latitude = 0.0;
  double longitude = 0.0;

  Stream<bool> get locationStream => locationStreamController.stream;

  LocationUpdater() {
    locationStreamController.add(false); // Set nilai awal stream controller menjadi false saat objek LocationUpdater dibuat
  }

  void startLocationUpdates() {
  location.requestPermission().then((permissionStatus) {
    if (permissionStatus == PermissionStatus.granted) {
      try {
        TrustLocation.start(3);
        TrustLocation.onChange.listen((values) {
          locationStreamController.add(values.isMockLocation!);
          latitude = double.tryParse(values.latitude ?? '') ?? 0.0;
          longitude = double.tryParse(values.longitude ?? '') ?? 0.0;
        });
      } catch (error) {
        if (kDebugMode) {
          print('Error starting location updates: $error');
        }
      }
    }
  });
}


  void dispose() {
    TrustLocation.stop();
    locationStreamController.close();
  }
}
