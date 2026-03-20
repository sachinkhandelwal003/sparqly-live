import 'dart:async';
import 'dart:math' as Math;
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Filters.dart';
import '../../../models/Get_Models_All/offer_Get_Models.dart';
import '../../../models/Get_Models_All/priority_search_request.dart';
import '../../../services/location services/Location.dart';

class OffersController extends GetxController implements SearchFilterController {
  /// Offers list from API
  var offersList = <OfferData>[].obs;
  var selectedId = 0.obs;

  /// Filters
  var searchQuery = "".obs;
  var selectedCategory = "All".obs;
  var selectedRadius = 0.0.obs;

  /// States
  var isLoading = false.obs;
  var errorMessage = "".obs;

  /// ✅ Location service instance
  LocationAccesss locationAccess = Get.put(LocationAccesss());

  final PrioritySearchController prioritySearchController =
  Get.put(PrioritySearchController());


  @override
  void onInit() {
    super.onInit();
    fetchOffers();

    // 🔥 SYNC CATEGORY
    ever(prioritySearchController.selectedCategory, (value) {
      selectedCategory.value = value;
    });

    // 🔥 SYNC RADIUS
    ever(prioritySearchController.selectedRadius, (value) {
      selectedRadius.value = value;
    });
  }



  /// Combined filtering
  List<OfferData> get filteredOffers {
    final radius = selectedRadius.value;

    return offersList.where((offer) {
      final query = searchQuery.value.toLowerCase();

      final matchesSearch = query.isEmpty ||
          offer.title.toLowerCase().contains(query) ||
          offer.description.toLowerCase().contains(query) ||
          offer.location.toLowerCase().contains(query);

      final matchesCategory = selectedCategory.value == "All" ||
          selectedCategory.value.isEmpty ||
          offer.targetAudience.toLowerCase() ==
              selectedCategory.value.toLowerCase();

      bool matchesDistance = true;

      // ✅ Distance filter: skip if radius = 0
      if (radius != 0) {
        if (offer.latitude != null && offer.longitude != null) {
          final distance = _calculateDistance(
            locationAccess.latitude.value,
            locationAccess.longitude.value,
            double.tryParse(offer.latitude.toString()) ?? 0.0,
            double.tryParse(offer.longitude.toString()) ?? 0.0,
          );
          matchesDistance = distance <= radius;
        }
      }

      return matchesSearch && matchesCategory && matchesDistance;
    }).toList();
  }

  /// 🌍 Haversine formula for distance (in km)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // pi / 180
    final a = 0.5 -
        Math.cos((lat2 - lat1) * p) / 2 +
        Math.cos(lat1 * p) *
            Math.cos(lat2 * p) *
            (1 - Math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Update search query
  @override
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  /// Update category
  @override
  void updateCategory(String value) {
    selectedCategory.value = value;
  }

  /// Update radius
  @override
  void updateRadius(double value) {
    selectedRadius.value = value;
  }



  List<OfferData> applyCategoryAndRadiusFilter(
      List<OfferData> sourceList) {

    final query = searchQuery.value.toLowerCase();
    final radius = selectedRadius.value;

    return sourceList.where((offer) {
      final title = offer.title.toLowerCase();
      final description = offer.description.toLowerCase();
      final location = offer.location.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
              title.contains(query) ||
              description.contains(query) ||
              location.contains(query);

      bool matchesDistance = true;

      if (radius != 0 &&
          offer.latitude != null &&
          offer.longitude != null) {
        final distance = _calculateDistance(
          locationAccess.latitude.value,
          locationAccess.longitude.value,
          double.tryParse(offer.latitude.toString()) ?? 0.0,
          double.tryParse(offer.longitude.toString()) ?? 0.0,
        );
        matchesDistance = distance <= radius;
      }

      return matchesSearch && matchesDistance;
    }).toList();
  }


  /// Fetch offers from API
  Future<void> fetchOffers() async {
    try {
      isLoading(true);
      errorMessage("");

      // ✅ Check internet connection
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      final response = await ApiServices().getItem<OfferListResponse>(
        endpoint: "get-offer",
        fromJson: (json) => OfferListResponse.fromJson(json),
      ).timeout(const Duration(seconds: 15));

      if (response != null && response.status) {
        offersList.assignAll(response.data);

        prioritySearchController.setFallbackList(
          response.data.map((e) => e.toJson()).toList(),
          type: "offer",
        );

        print("✅ Offers fetched: ${offersList.length}");
      } else {
        errorMessage(response?.message ?? "Failed to fetch offers");
      }
    } on TimeoutException {
      errorMessage("Request timed out. Please try again.");
    } on FormatException {
      errorMessage("Data format error. Please contact support.");
    } catch (e) {
      errorMessage("Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }
}
