import 'dart:async';
import 'dart:math' as Math;
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../models/Get_Models_All/job_Get_Models.dart';
import '../../../models/Get_Models_All/priority_search_request.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';

class JobsController extends GetxController implements SearchFilterController {
  // Jobs list from API
  var jobsList = <JobData>[].obs;

  var selectedId = 0.obs;

  // Search query
  var searchQuery = "".obs;

  // Selected category filter
  @override
  var selectedCategory = "All".obs; // ✅ default to "All"

  // Selected radius filter
  @override
  var selectedRadius = 0.0.obs;

  // Loading state
  var isLoading = false.obs;

  // Error message
  var errorMessage = "".obs;

  // Location instance
  LocationAccesss locationAccess = Get.put(LocationAccesss());
  final PrioritySearchController prioritySearchController =
  Get.put(
    PrioritySearchController(),
    tag: "job",
  );


  @override
  void onInit() {
    super.onInit();
    fetchJobs();

    ever(prioritySearchController.selectedCategory, (value) {
      selectedCategory.value = value;
    });

    ever(prioritySearchController.selectedRadius, (value) {
      selectedRadius.value = value;
    });


  }

  // Combined filtering with distance
  List<JobData> get filteredJobs {
    final query = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value.trim().toLowerCase();
    final radius = selectedRadius.value;

    final list = jobsList.where((job) {
      final title = job.title?.toLowerCase() ?? "";
      final company = job.companyName?.toLowerCase() ?? "";
      final location = job.location?.toLowerCase() ?? "";
      final type = job.jobType?.toLowerCase() ?? "other";

      final matchesSearch =
          query.isEmpty || title.contains(query) || company.contains(query) || location.contains(query);

      final matchesCategory =
          category == 'all' || category.isEmpty || type == category;

      bool matchesDistance = true;

      // ✅ Distance filtering: skip if radius = 0
      if (radius != 0) {
        if (job.latitude != null && job.longitude != null) {
          final distance = _calculateDistance(
            locationAccess.latitude.value,
            locationAccess.longitude.value,
            double.tryParse(job.latitude.toString()) ?? 0.0,
            double.tryParse(job.longitude.toString()) ?? 0.0,
          );
          matchesDistance = distance <= radius;
        }
      }

      final include = matchesSearch && matchesCategory && matchesDistance;

      // Debug log
      print('Job: ${job.title}, Type: ${job.jobType}, Radius: $radius, DistOK: $matchesDistance, Include: $include');

      return include;
    }).toList();

    print('Filtered jobs length: ${list.length}');
    return list;
  }

  // 🌍 Haversine formula for distance (in km)
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

  // Update search
  @override
  void updateSearch(String query) {
    searchQuery.value = query;
    print("🔍 Updated search → $query");
  }

  // Update category
  @override
  void updateCategory(String value) {
    selectedCategory.value = value;
    print("📂 Updated category → $value");
  }

  // Update radius
  @override
  void updateRadius(double value) {
    selectedRadius.value = value;
    print("📍 Updated radius → $value km");
  }

  List<JobData> applyCategoryAndRadiusFilter(List<JobData> sourceList) {
    final query = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value.trim().toLowerCase();
    final radius = selectedRadius.value;

    return sourceList.where((job) {
      final title = job.title?.toLowerCase() ?? "";
      final company = job.companyName?.toLowerCase() ?? "";
      final location = job.location?.toLowerCase() ?? "";
      final type = job.jobType?.toLowerCase() ?? "other";

      final matchesSearch =
          query.isEmpty ||
              title.contains(query) ||
              company.contains(query) ||
              location.contains(query);

      final matchesCategory =
          category == 'all' || category.isEmpty || type == category;

      bool matchesDistance = true;

      // ✅ Distance filtering: skip if radius = 0
      if (radius != 0) {
        if (job.latitude != null && job.longitude != null) {
          final distance = _calculateDistance(
            locationAccess.latitude.value,
            locationAccess.longitude.value,
            double.tryParse(job.latitude.toString()) ?? 0.0,
            double.tryParse(job.longitude.toString()) ?? 0.0,
          );
          matchesDistance = distance <= radius;
        }
      }

      return matchesSearch && matchesCategory && matchesDistance;
    }).toList();
  }



  // Fetch jobs from API
  Future<void> fetchJobs() async {
    try {
      isLoading(true);
      errorMessage("");

      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      final response = await ApiServices().getItem<JobListResponse>(
        endpoint: "get-jobs",
        fromJson: (json) => JobListResponse.fromJson(json),
      ).timeout(const Duration(seconds: 15));

      if (response != null && response.status) {
        jobsList.assignAll(response.data);

        prioritySearchController.setFallbackList(
          response.data.map((e) => e.toJson()).toList(),
          type: "job",
        );

        print("✅ Jobs fetched: ${jobsList.length}");
      } else {
        errorMessage(response?.message ?? "Failed to fetch jobs");
      }
    } on TimeoutException {
      errorMessage("Request timed out. Please try again.");
    } on FormatException {
      errorMessage("Data format error. Please contact support.");
    } catch (e) {
      errorMessage("Something went wrong: $e");
      print("❌ Jobs API error: $e");
    } finally {
      isLoading(false);
    }
  }
}
