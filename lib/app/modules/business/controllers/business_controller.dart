import 'dart:async';
import 'dart:math' as Math;
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sparqly/app/models/Get_Models_All/offer_Get_Models.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import 'package:sparqly/app/services/location%20services/Location.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Filters.dart';
import '../../../models/Get_Models_All/business_Get_Model.dart';
import '../../../models/Get_Models_All/priority_search_request.dart';

class BusinessController extends GetxController
    implements SearchFilterController {
  var categories = <String>[].obs;
  var businessList = <BusinessData>[].obs;
  var searchQuery = "".obs;
  var selectedCategory = "All".obs;
  var selectedRadius = 0.0.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var selectedId = 0.obs;
  var isDeepLinkNavigation = false; // 👈 Add this flag

  LocationAccesss locationAccess = Get.put(LocationAccesss());
  final PrioritySearchController prioritySearchController = Get.put(
    PrioritySearchController(),
    tag: "business",
  );

  @override
  void onInit() {
    super.onInit();
    fetchBusinesses();
    ever(prioritySearchController.selectedCategory, (value) {
      selectedCategory.value = value;
    });
    ever(prioritySearchController.selectedRadius, (value) {
      selectedRadius.value = value;
    });
  }

  List<BusinessData> get filteredBusinesses {
    final query = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value.trim().toLowerCase();
    final radius = selectedRadius.value;

    final list = businessList.where((item) {
      final name = (item.name ?? '').trim().toLowerCase();
      final location = (item.location ?? '').trim().toLowerCase();
      final businessCategory = (item.businessCategory ?? 'unknown')
          .trim()
          .toLowerCase();

      final matchesSearch =
          query.isEmpty || name.contains(query) || location.contains(query);
      final matchesCategory =
          category == 'all' || category.isEmpty || businessCategory == category;

      bool matchesDistance = true;

      if (radius != 0) {
        final distance = _calculateDistance(
          locationAccess.latitude.value,
          locationAccess.longitude.value,
          double.tryParse(item.latitude.toString()) ?? 0.0,
          double.tryParse(item.longitude.toString()) ?? 0.0,
        );
        matchesDistance = distance <= radius;
      } else {
        matchesDistance = true;
      }
      final include = matchesSearch && matchesCategory && matchesDistance;
      print(
        'Item: ${item.name}, Cat: ${item.businessCategory}, Radius: $radius, DistOK: $matchesDistance, Include: $include',
      );
      return include;
    }).toList();
    print('Filtered list length: ${list.length}');
    return list;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    final a =
        0.5 -
        Math.cos((lat2 - lat1) * p) / 2 +
        Math.cos(lat1 * p) *
            Math.cos(lat2 * p) *
            (1 - Math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * Math.asin(Math.sqrt(a));
  }

  void updateSearch(String query) => searchQuery.value = query;
  void updateCategory(String value) => selectedCategory.value = value;
  void updateRadius(double value) => selectedRadius.value = value;

  List<BusinessData> applyCategoryAndRadiusFilter(
    List<BusinessData> sourceList,
  ) {
    final category = selectedCategory.value.trim().toLowerCase();
    final radius = selectedRadius.value;

    return sourceList.where((item) {
      final businessCategory = (item.businessCategory ?? '')
          .trim()
          .toLowerCase();

      final matchesCategory =
          category == 'all' || category.isEmpty || businessCategory == category;

      bool matchesDistance = true;
      if (radius != 0) {
        final distance = _calculateDistance(
          locationAccess.latitude.value,
          locationAccess.longitude.value,
          double.tryParse(item.latitude.toString()) ?? 0.0,
          double.tryParse(item.longitude.toString()) ?? 0.0,
        );
        matchesDistance = distance <= radius;
      }

      return matchesCategory && matchesDistance;
    }).toList();
  }

  Future<void> fetchBusinesses() async {
    try {
      isLoading(true);
      errorMessage("");

      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      final response = await ApiServices()
          .getItem<BusinessListResponse>(
            endpoint: "get-businesses",
            fromJson: (json) => BusinessListResponse.fromJson(json),
          )
          .timeout(const Duration(seconds: 15));

      if (response != null && response.status) {
        businessList.assignAll(response.data);

        prioritySearchController.setFallbackList(
          response.data.map((e) => e.toJson()).toList(),
          type: "business",
        );

        categories.assignAll([
          "All",
          ...response.data
              .map((e) => (e.businessCategory ?? 'Unknown').trim())
              .toSet()
              .toList(),
        ]);
      } else {
        errorMessage(response?.message ?? "Failed to fetch businesses");
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

  var offers = <OfferData>[].obs;
  var isLoadingFilter = false.obs;
  var errorMessageFilter = ''.obs;

  Future<void> fetchNearbyOffers({
    required double latitude,
    required double longitude,
    required double radius,
    required String type,
  }) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      final response = await ApiServices().fetchOffersByLocation(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        type: type,
      );

      if (response != null && response["status"] == true) {
        final List<dynamic> data = response["data"];
        offers.value = data.map((e) => OfferData.fromJson(e)).toList();
        print("Offers fetched: ${offers.length}");
      } else {
        errorMessage.value = response?["message"] ?? "No offers found";
        offers.clear();
      }
    } catch (e) {
      errorMessage.value = "Error fetching offers: $e";
      print("Controller Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
