import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/App_Colors.dart';
import '../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'Location.dart';

class LocationPicker extends StatelessWidget {
  final LocationAccesss controller;
  final double mapHeight;
  final String? locationTitle;
  final Color? widthColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? latitude;   // optional lat
  final double? longitude;  // optional long

  const LocationPicker({
    Key? key,
    required this.controller,
    this.mapHeight = 200,
    this.locationTitle,
    this.widthColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final initialLat =  controller.latitudeListing.value;
    final initialLng =  controller.longitudeListing.value;
    return AppCustomContainer(
      widthColor: widthColor ?? AppColors.dividercolor,
      borderradius: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 12, vertical: verticalPadding ?? 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        AppCustomTexts(
        TextName:locationTitle ??  "Location",
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Times New Roman",
          ),
        ),
          SizedBox(height: mediaQuery.size.height * 0.01),

            // Map container
            AppCustomContainer(
              height: mapHeight,
              borderradius: 16,
              widthColor: Colors.grey.shade300,
              widthsize: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(
                      () => GoogleMap(
                    mapType: MapType.normal,
                    buildingsEnabled: true,
                    compassEnabled: true,
                    mapToolbarEnabled: true,
                    rotateGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    scrollGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    minMaxZoomPreference:
                    MinMaxZoomPreference(controller.minZoom, controller.maxZoom),
                    onMapCreated: controller.setMapController,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(initialLat, initialLng),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("location_marker"),
                        position: LatLng(controller.latitudeListing.value,
                            controller.longitudeListing.value),
                        infoWindow: const InfoWindow(title: "Selected Location"),
                        draggable: true,
                        onDragEnd: controller.updateAddressFromLatLng,
                        visible: true,

                      ),

                    },
                    onTap: controller.updateAddressFromLatLng,
                  ),
                ),
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),

            // Optional Address input
              TextFormField(
                controller: controller.locationController,
                decoration: InputDecoration(
                  labelText: "Address",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: controller.updateLatLngFromAddress,
              ),
          ],
        ),
      ),
    );
  }
}

