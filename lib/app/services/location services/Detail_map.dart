import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/Custom_Widgets/App_Custom_Container.dart';


class LocationViewer extends StatelessWidget {
  final dynamic latitude;
  final dynamic longitude;
  final double mapHeight;
  final String? locationTitle;

  const LocationViewer({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.mapHeight = 200,
    this.locationTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lat = _parseCoordinate(latitude);
    final lng = _parseCoordinate(longitude);

    // If valid → show Google Map with marker
    return AppCustomContainer(
      borderradius: 10,
      child: AppCustomContainer(
        height: mapHeight,
        borderradius: 16,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                lat ?? 0.0,
                lng ?? 0.0,
              ),
              zoom: lat != null && lng != null ? 14 : 2, // zoom out if invalid
            ),
            markers: {
              Marker(
                markerId: const MarkerId("business_marker"),
                position: LatLng(
                  lat ?? 0.0,
                  lng ?? 0.0,
                ),
                infoWindow: InfoWindow(
                  title: lat != null && lng != null
                      ? locationTitle ?? "Business Location"
                      : "Location not correct",
                ),
              ),
            },
            myLocationEnabled: false,
            zoomControlsEnabled: true,
            scrollGesturesEnabled: true,
          ),
        ),
      ),
    );
  }

  // Parses dynamic value (String/double/int) into double
  // Cleans API strings like "26.8408° N" → 26.8408
  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Remove non-numeric characters except dot and minus
      final cleaned = value.replaceAll(RegExp(r'[^0-9.-]'), '');
      return double.tryParse(cleaned);
    }
    return null;
  }
}
