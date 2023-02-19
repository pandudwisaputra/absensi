import 'dart:async';
import 'package:absensi/apiLoc/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  final StreamController<Userlocation> _locationStreameController =
      StreamController<Userlocation>();
  Stream<Userlocation> get locationStrem => _locationStreameController.stream;

  LocationService() {
    location.requestPermission().then(
      (permissionStatus) {
        if (permissionStatus == PermissionStatus.granted) {
          location.onLocationChanged.listen(
            (locationData) {
              _locationStreameController.add(
                Userlocation(
                  latitude: locationData.latitude!,
                  longtitude: locationData.longitude!,
                ),
              );
            },
          );
        }
      },
    );
  }
  void dispose() => _locationStreameController.close();
}
