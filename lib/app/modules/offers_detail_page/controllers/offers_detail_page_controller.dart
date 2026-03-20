import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Get_Models_All/All_Detail_ui_models/offer_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../offers/controllers/offers_controller.dart';
import 'package:get_storage/get_storage.dart';

class OffersDetailPageController extends GetxController {
  var isExpanded = false.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var offerDetail = Rxn<OfferDetails>();

  final OffersController offersController = Get.find<OffersController>();


  @override
  void onInit() {
    super.onInit();

    // React to changes in selectedId
    ever<int>(offersController.selectedId, (id) {
      print("🔄 Offer selectedId changed: $id");
      fetchOfferDetail(id);
      fetchReviewsInfluencer(); // ✅ also fetch reviews when ID changes
    });

    // Initial fetch
    fetchOfferDetail(offersController.selectedId.value);
    fetchReviewsInfluencer(); // ✅ fetch on init too

    // Load stored user id properly into Rx
    final storedUserId = GetStorage().read('user_id')?.toString();
    final parsedUserId = storedUserId != null ? int.tryParse(storedUserId) : null;

    if (parsedUserId != null) {
      currentUserId.value = parsedUserId;
      print("✅ Current user id set: ${currentUserId.value}");
    } else {
      print("❌ No valid user_id found in storage.");
    }
  }




  /// Fetch Offer detail by ID
  Future<void> fetchOfferDetail(int offerId) async {
    try {
      isLoading(true);
      errorMessage("");

      // ✅ Check internet connection
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      // ✅ API call with timeout
      final response = await ApiServices()
          .getDetailItem<OfferDetailsResponse>(
        endpoint: "offer-details?offer_id=$offerId",
        fromJson: (json) => OfferDetailsResponse.fromJson(json),
      )
          .timeout(const Duration(seconds: 15));

      if (response != null && response.status && response.data != null) {
        offerDetail.value = response.data; // store offer object

        callPostApi(
          data: {
            "data_id": offerId,
            "data_type": "offer",
            "list_creator_id": offerDetail.value?.UserId ?? 0,
          },
        );

      } else {
        errorMessage(response?.message ?? "Failed to fetch offer details");
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

      print("📤 Starting fetchReviews for job_id: ${offersController.selectedId.value}");

      final data = await ApiServices().fetchReviewData(
        endpoint: "offer/get-reviews",
        idKey: "offer_id",
        idValue: offersController.selectedId.value,
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
    const endpoint = "offer/review/store"; // your API endpoint
    const idField = "offer_id";           // the field name for business ID
    final int idValue = offersController.selectedId.value; // current business ID

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
        fetchReviewsInfluencer();
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
