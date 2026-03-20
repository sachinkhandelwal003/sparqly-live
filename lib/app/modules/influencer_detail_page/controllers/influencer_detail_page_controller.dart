import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Get_Models_All/All_Detail_ui_models/influencer_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../influencers/controllers/influencers_controller.dart';
import 'package:get_storage/get_storage.dart';


class InfluencerDetailPageController extends GetxController {
  var isExpanded = false.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var influencerDetail = Rxn<InfluencerDetails>();

  final InfluencersController influencersController = Get.find<InfluencersController>();

  @override
  void onInit() {
    super.onInit();

    final storedUserId = GetStorage().read('user_id')?.toString();
    final parsedUserId = storedUserId != null ? int.tryParse(storedUserId) : null;

    if (parsedUserId == null) {
      print("❌ No valid user_id found in storage.");
      return;
    }

    currentUserId.value = parsedUserId; // ✅ assign to RxInt

    print("✅ Current user id set: ${currentUserId.value}");

    // React to changes in selectedId
    ever<int>(influencersController.selectedId, (id) {
      print("🔄 Influencer selectedId changed: $id");
      fetchInfluencerDetail(id);
      fetchReviewsInfluencer();
    });

    // Initial fetch
    fetchInfluencerDetail(influencersController.selectedId.value);
    fetchReviewsInfluencer(); // ✅ ensure first reviews load
  }





  /// Fetch Influencer detail by ID
  Future<void> fetchInfluencerDetail(int influencerId) async {
    try {
      isLoading(true);
      errorMessage("");

      //  Check internet connection
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      //  API call
      final response = await ApiServices()
          .getDetailItem<InfluencerDetailsResponse>(
        endpoint: "influencer-details?influencer_id=$influencerId",
        fromJson: (json) => InfluencerDetailsResponse.fromJson(json),
      )
          .timeout(const Duration(seconds: 15));

      if (response != null && response.status && response.data != null) {
        influencerDetail.value = response.data; //  set influencer object

        callPostApi(
          data: {
            "data_id": influencerId,
            "data_type": "influencer",
            "list_creator_id": influencerDetail.value?.userId ?? 0,
          },
        );

      } else {
        errorMessage(response?.message ?? "Failed to fetch influencer details");
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



  var currentUserId = 0.obs;
  var showAllReviews = false.obs;
  var rating = 0.obs;
  var isEditing = false.obs;


  // Reviews
  var reviews = <Map<String, dynamic>>[].obs;
  var averageRating = 0.0.obs;
  var isLoadingReview = false.obs;
  var errorMessageReview = ''.obs;
  int? editingReviewId;
  var isLoadingSubmitReview = false.obs;
  var errorMessageSubmitReview = ''.obs;
  final commentController = TextEditingController();

  /// Update rating
  void updateRating(int value) {
    rating.value = value;
  }

  /// Fetch reviews from API

  Future<void>


  fetchReviewsInfluencer() async {
    try {
      isLoadingReview(true);
      errorMessageReview("");

      print("📤 Starting fetchReviews for job_id: ${influencersController.selectedId.value}");

      final data = await ApiServices().fetchReviewData(
        endpoint: "influencer/get-reviews",
        idKey: "influencer_id",
        idValue: influencersController.selectedId.value,
      );

      print("✅ Reviews fetched successfully. Count: ${data.length}");

      reviews.value = data;

      // Recalculate average rating
      _calculateAverageRating();
    } on TimeoutException catch (e) {
      errorMessageReview.value = "⏳ Request timed out: $e";
      print("❌ Timeout in fetchReviews: $e");
    } on FormatException catch (e) {
      errorMessageReview.value = "⚠️ Bad response format: $e";
      print("❌ FormatException in fetchReviews: $e");
    } on SocketException catch (e) {
      errorMessageReview.value = "📡 No internet connection: $e";
      print("❌ SocketException in fetchReviews: $e");
    } catch (e, stack) {
      errorMessageReview.value = "❌ Unexpected error: $e";
      print("❌ Unexpected error in fetchReviews: $e");
      print("Stack trace: $stack");
    } finally {
      isLoadingReview(false);
      print("🔚 fetchReviews finished");
    }
  }


  /// Submit or update review
  Future<void> submitReview() async {
    const endpoint = "influencer/review/store"; // your API endpoint
    const idField = "influencer_id";           // the field name for business ID
    final int idValue = influencersController.selectedId.value; // current business ID

    try {
      isLoadingSubmitReview(true);

      final newReview = await ApiServices().submitReview(
        endpoint: endpoint,
        idField: idField,
        idValue: idValue,
        rating: rating.value,
        review: commentController.text,
        reviewId: isEditing.value ? editingReviewId : null,
      );

      // API returns a `data` object containing the new review
      if (isEditing.value) {
        // Update existing review in the list
        final index = reviews.indexWhere(
                (r) => r['id'].toString() == editingReviewId.toString());
        if (index != -1) {
          reviews[index] = newReview;
        }
        isEditing.value = false;
        editingReviewId = null;
      } else {
        // Add new review at top
        reviews.insert(0, newReview);
      }

      // Recalculate average rating
      _calculateAverageRating();

      // Clear inputs
      commentController.clear();
      rating.value = 0;

      print("✅ Review submitted successfully: $newReview");
    } catch (e) {
      print("❌ Error submitting review: $e");
    } finally {
      isLoadingSubmitReview(false);
    }
  }


  /// Start editing a review
  void startEditing(Map<String, dynamic> review) {
    isEditing.value = true;
    editingReviewId = review['id'] != null
        ? int.tryParse(review['id'].toString())
        : null;
    commentController.text = review['review']?.toString() ?? '';
    rating.value = int.tryParse(review['rating']?.toString() ?? '0') ?? 0;
  }

  /// Calculate average rating
  void _calculateAverageRating() {
    if (reviews.isEmpty) {
      averageRating.value = 0.0;
    } else {
      final total = reviews.fold<int>(
        0,
            (sum, r) => sum + (int.tryParse(r['rating']?.toString() ?? '0') ?? 0),
      );
      averageRating.value = total / reviews.length;
    }
  }


  // Store response reactively
  var responseData = <String, dynamic>{}.obs;

  // Call API with endpoint and data provided at runtime
  Future<void> callPostApi({required Map<String, dynamic> data}) async {
    final response = await ApiServices().postData(data);

    const yellow = '\x1B[33m';
    const reset = '\x1B[0m';

    if (response != null) {
      responseData.value = response;
      print("$yellow✅ API Response (POST analytics/store): $response$yellow");
    } else {
      responseData.value = {};
      print("$yellow⚠️ API Response is null or failed$yellow");
    }
  }

  Future<void> openWebsite(String? url) async {
    if (url == null || url.trim().isEmpty) {
      Get.snackbar("Unavailable", "Website link not available");
      return;
    }

    final Uri uri = Uri.parse(
      url.startsWith("http") ? url : "https://$url",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar("Error", "Could not open website");
    }
  }
}

