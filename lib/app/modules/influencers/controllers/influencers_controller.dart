import 'dart:async';
import 'dart:math' as Math;
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../models/Get_Models_All/influencer_Get_Models.dart';
import '../../../models/Get_Models_All/priority_search_request.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';

class InfluencersController extends GetxController implements SearchFilterController {
  var influencerList = <InfluencerData>[].obs; // fetched data
  var filteredInfluencers = <InfluencerData>[].obs; // filtered data
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var searchQuery = "".obs;
  var selectedId = 0.obs;

  @override
  var selectedCategory = "".obs;
  @override
  var selectedRadius = 0.0.obs;

  // ✅ Location service instance
  LocationAccesss locationAccess = Get.put(LocationAccesss());
  final PrioritySearchController prioritySearchController =
  Get.put(
    PrioritySearchController(),
    tag: "influencer",
  );


  @override
  void onInit() {
    super.onInit();
    fetchInfluencers();

    ever(prioritySearchController.selectedCategory, (value) {
      selectedCategory.value = value;
    });

    ever(prioritySearchController.selectedRadius, (value) {
      selectedRadius.value = value;
    });


  }

  /// 🔹 Apply search, category, and radius filters
  void applyFilters() {
    final query = searchQuery.value.toLowerCase();
    final category = selectedCategory.value.toLowerCase();
    final radius = selectedRadius.value;

    filteredInfluencers.assignAll(
      influencerList.where((item) {
        final name = item.name.toLowerCase();
        final niche = item.niche.toLowerCase();

        final matchesSearch = query.isEmpty || name.contains(query) || niche.contains(query);

        final matchesCategory = category == "all" || category.isEmpty || niche == category;

        bool matchesDistance = true;

        // ✅ Distance filtering: skip if radius = 0
        if (radius != 0) {
          if (item.latitude != null && item.longitude != null) {
            final distance = _calculateDistance(
              locationAccess.latitude.value,
              locationAccess.longitude.value,
              double.tryParse(item.latitude.toString()) ?? 0.0,
              double.tryParse(item.longitude.toString()) ?? 0.0,
            );
            matchesDistance = distance <= radius;
          }
        }

        return matchesSearch && matchesCategory && matchesDistance;
      }).toList(),
    );

    print('Filtered influencers length: ${filteredInfluencers.length}');
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

  /// 🔹 Update search text
  @override
  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  /// 🔹 Update selected category
  @override
  void updateCategory(String value) {
    selectedCategory.value = value;
    applyFilters();
  }

  /// 🔹 Update radius
  @override
  void updateRadius(double value) {
    selectedRadius.value = value;
    applyFilters();
  }

  List<InfluencerData> applyCategoryAndRadiusFilter(
      List<InfluencerData> sourceList) {

    final query = searchQuery.value.toLowerCase();
    final category = selectedCategory.value.toLowerCase();
    final radius = selectedRadius.value;

    return sourceList.where((item) {
      final name = item.name.toLowerCase();
      final niche = item.niche.toLowerCase();

      final matchesSearch =
          query.isEmpty || name.contains(query) || niche.contains(query);

      final matchesCategory =
          category == "all" || category.isEmpty || niche == category;

      bool matchesDistance = true;

      if (radius != 0) {
        if (item.latitude != null && item.longitude != null) {
          final distance = _calculateDistance(
            locationAccess.latitude.value,
            locationAccess.longitude.value,
            double.tryParse(item.latitude.toString()) ?? 0.0,
            double.tryParse(item.longitude.toString()) ?? 0.0,
          );
          matchesDistance = distance <= radius;
        }
      }

      return matchesSearch && matchesCategory && matchesDistance;
    }).toList();
  }


  /// 🔹 Fetch Influencers from API
  Future<void> fetchInfluencers() async {
    try {
      isLoading(true);
      errorMessage("");

      // Check internet connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      final response = await ApiServices().getItem<InfluencerListResponse>(
        endpoint: "get-influencers",
        fromJson: (json) => InfluencerListResponse.fromJson(json),
      ).timeout(const Duration(seconds: 15));

      if (response != null && response.status) {
        influencerList.assignAll(response.data);
        prioritySearchController.setFallbackList(
          response.data.map((e) => e.toJson()).toList(),
          type: "influencer",
        );
        applyFilters();
        print("✅ Influencers fetched: ${influencerList.length}");
      } else {
        errorMessage(response?.message ?? "Failed to fetch influencers");
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
