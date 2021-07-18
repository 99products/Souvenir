import 'package:geocoder/geocoder.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:location/location.dart';

Location location = new Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

double calculateDistanceBetweenTwoPoints(lat1, lon1, lat2, lon2){
  //double distance = await Geolocator().distanceBetween( startLatitude, startLongitude, endLatitude, endLongitude);
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

Future<LocationData> getLocationData() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  return await location.getLocation();
}

Future<String> getLocationAddress(LocationData loc) async
{
  final coordinates = new Coordinates(
      loc.latitude, loc.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(
      coordinates);
  var first = addresses.first;

  return '${first.subLocality}, ${first.locality}, ${first.adminArea}';
  //print('locality ${first.locality},adminArea ${first.adminArea},subLocality ${first.subLocality},subAdminArea ${first.subAdminArea},addressLine ${first.addressLine},featureName ${first.featureName},thoroughfare ${first.thoroughfare},subThoroughfare ${first.subThoroughfare}');
}