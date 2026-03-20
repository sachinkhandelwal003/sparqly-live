import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationAccesss extends GetxController {
  RxString address = ''.obs;
  RxString shoppingCartLocation = ''.obs;
  RxString subtitlelocation = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool permissionChecked = false.obs;

  Future<void> locationaccess() async {
    if (permissionChecked.value) return;
    permissionChecked.value = true;

    try {
      bool serviceEnable = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnable) {
        Get.snackbar("Error", "Location service is disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "You denied location permission.");
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied Forever",
          "Go to settings and allow location manually.",
        );
        await Geolocator.openAppSettings();
        return;
      }

      // ✅ Permission granted
      print("✔ Location permission granted");
    } catch (e, stacktrace) {
      print(e.toString() + stacktrace.toString());
    }
  }

  Future<void> getposition() async {
    try {
      // 1️⃣ Try last known location first (instant, may be cached)
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null) {
        latitude.value = lastPosition.latitude;
        longitude.value = lastPosition.longitude;
        await getlocation(lastPosition.longitude, lastPosition.latitude);
        print("📍 Used last known location: ${lastPosition.latitude}, ${lastPosition.longitude}");
      }

      // 2️⃣ Then fetch fresh GPS in background (more accurate)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      await getlocation(position.longitude, position.latitude);

      print("📍 Updated with fresh GPS: ${position.latitude}, ${position.longitude}");
    } catch (e, stacktrace) {
      print("❌ Error getting position: $e\n$stacktrace");
    }
  }


  Future<void> getlocation(double longitude, double latitude) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    Placemark place = placemark[0];

    address.value =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    shoppingCartLocation.value =
        '${place.name}, '
        '${place.street}, '
        '${place.subLocality}, '
        '${place.locality}';
    subtitlelocation.value =
        '${place.administrativeArea},'
        '${place.country}';
  }











  /// location picker for google map code

  var latitudeListing = 20.5937.obs;
  var longitudeListing = 78.9629.obs;
  var location = ''.obs;

  GoogleMapController? mapController;

  final locationController = TextEditingController();

  double minZoom = 3;
  double maxZoom = 20;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> updateAddressFromLatLng(LatLng pos) async {
    latitudeListing.value = pos.latitude;
    longitudeListing.value = pos.longitude;

    try {
      final placemarks = await placemarkFromCoordinates(latitudeListing.value, longitudeListing.value);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        location.value =
        "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
        locationController.text = location.value;
      }
    } catch (e) {
      print("Error fetching address: $e");
    }

    _moveCamera(LatLng(latitudeListing.value, longitudeListing.value), zoom: 16);
  }

  Future<void> updateLatLngFromAddress(String address) async {
    try {
      final loc = await locationFromAddress(address);
      if (loc.isNotEmpty) {
        latitudeListing.value = loc.first.latitude;
        longitudeListing.value = loc.first.longitude;
        _moveCamera(LatLng(latitudeListing.value, longitudeListing.value), zoom: 16);
      }
    } catch (e) {
      print("Error fetching coordinates: $e");
    }
  }

  void _moveCamera(LatLng target, {double zoom = 14}) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: zoom)),
    );
  }
}
