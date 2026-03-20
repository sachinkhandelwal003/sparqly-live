import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Get_Models_All/All_Detail_ui_models/business_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../business/controllers/business_controller.dart';

class BusinessDetailPageController extends GetxController {
  // Reactive variables
  var isExpanded = false.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var businessDetail = Rxn<BusinessDetails>();
  var userId = 0.obs;
  var selectedId = 0.obs;
  var showAllReviews = false.obs;
  var rating = 0.obs;
  var currentUserId = 0.obs;
  var reviews = <Map<String, dynamic>>[].obs;
  var averageRating = 0.0.obs;
  var isLoadingReview = false.obs;
  var errorMessageReview = ''.obs;
  var isLoadingSubmitReview = false.obs;
  var errorMessageSubmitReview = ''.obs;
  final commentController = TextEditingController();
  final BusinessController businessController = Get.find<BusinessController>();

  // @override
  // void onInit() {
  //   super.onInit();
  //
  //   ever<int>(businessController.selectedId, (id) {
  //     if (id > 0) {
  //       fetchBusinessDetail(id);
  //       fetchReviews();
  //     }
  //   });
  // }
  // BusinessDetailPageController.dart

  // BusinessDetailPageController.dart

  // @override
  // void onInit() {
  //   super.onInit();

  //   final dynamic argId = Get.arguments;

  //   if (argId != null) {
  //     // 1. Deep Link ya Manual Navigation se aaya hua ID
  //     int id = (argId is String) ? int.tryParse(argId) ?? 0 : argId;
  //     if (id > 0) {
  //       businessController.selectedId.value = id;
  //       _loadData(id);
  //     }
  //   } else if (businessController.selectedId.value > 0) {
  //     // 2. Fallback agar argument nahi hai par controller mein ID hai
  //     _loadData(businessController.selectedId.value);
  //   }

  //   // Listener for future changes
  //   ever<int>(businessController.selectedId, (id) {
  //     if (id > 0 && !isLoading.value) {
  //       _loadData(id);
  //     }
  //   });
  // }

  @override
  void onInit() {
    super.onInit();

    // Deep link ya goToPage dono cases handle honge
    final int id = businessController.selectedId.value;

    if (id > 0) {
      _loadData(id);
    }

    // ✅ ever listener — sirf tab trigger ho jab ID actually change ho
    ever<int>(businessController.selectedId, (newId) {
      if (newId > 0 && newId != businessDetail.value?.id) {
        _loadData(newId);
      }
    });
  }

  void _loadData(int id) {
    fetchBusinessDetail(id);
    fetchReviews();
  }

  // Helper method taaki baar-baar code na likhna pade
  void _loadInitialData(int id) {
    fetchBusinessDetail(id);
    fetchReviews();
  }

  Future<void> fetchBusinessDetail(int businessId) async {
    try {
      isLoading(true);
      errorMessage("");
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }
      final response = await ApiServices()
          .getDetailItem<BusinessDetailsResponse>(
            endpoint: "business-details?business_id=$businessId",
            fromJson: (json) => BusinessDetailsResponse.fromJson(json),
          )
          .timeout(const Duration(seconds: 15));

      if (response != null && response.status && response.data != null) {
        businessDetail.value = response.data;
        callPostApi(
          data: {
            "data_id": businessId,
            "data_type": "business",
            "list_creator_id": businessDetail.value?.UserId ?? 0,
          },
        );
      } else {
        errorMessage(response?.message ?? "Failed to fetch business details");
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

  void updateRating(int value) {
    rating.value = value;
  }

  Future<void> fetchReviews() async {
    try {
      isLoadingReview(true);
      errorMessageReview("");

      final data = await ApiServices().fetchReviewData(
        endpoint: "business/get-reviews",
        idKey: "business_id",
        idValue: businessController.selectedId.value,
      );
      reviews.value = data;
      _calculateAverageRating();
    } catch (e) {
      errorMessageReview.value = e.toString();
    } finally {
      isLoadingReview(false);
    }
  }

  var isEditing = false.obs;
  var editingReviewId = RxnInt();

  Future<void> submitReview() async {
    const endpoint = "business/review/store";
    const idField = "business_id";
    final int idValue = businessController.selectedId.value;

    try {
      isLoadingSubmitReview(true);
      final newReview = await ApiServices().submitReview(
        endpoint: endpoint,
        idField: idField,
        idValue: idValue,
        rating: rating.value,
        review: commentController.text,
        reviewId: isEditing.value ? editingReviewId.value : null,
      );

      fetchReviews();
      if (isEditing.value) {
        final index = reviews.indexWhere(
          (r) => r['id'].toString() == editingReviewId.value.toString(),
        );
        if (index != -1) {
          reviews[index] = newReview;
        }
        isEditing.value = false;
        editingReviewId.value = null;
      } else {
        reviews.insert(0, newReview);
      }

      _calculateAverageRating();

      commentController.clear();
      rating.value = 0;
    } catch (e) {
      print(" Error submitting review: $e");
    } finally {
      isLoadingSubmitReview(false);
    }
  }

  void startEditing(Map<String, dynamic> review) {
    isEditing.value = true;
    editingReviewId.value = review['id'] != null
        ? int.tryParse(review['id'].toString())
        : null;
    commentController.text = review['review']?.toString() ?? '';
    rating.value = int.tryParse(review['rating']?.toString() ?? '0') ?? 0;
  }

  void startEditingReview(Map<String, dynamic> review) {
    isEditing.value = true;
    editingReviewId.value = review['id'] != null
        ? int.tryParse(review['id'].toString())
        : null;
    commentController.text = review['review']?.toString() ?? '';
    rating.value = int.tryParse(review['rating']?.toString() ?? '0') ?? 0;
  }

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

  Future<void> openWebsite(String? url) async {
    if (url == null || url.trim().isEmpty) {
      Get.snackbar("Unavailable", "Website link not available");
      return;
    }

    final Uri uri = Uri.parse(url.startsWith("http") ? url : "https://$url");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open website");
    }
  }

  var responseData = <String, dynamic>{}.obs;

  Future<void> callPostApi({required Map<String, dynamic> data}) async {
    final response = await ApiServices().postData(data);
    if (response != null) {
      responseData.value = response;
    } else {
      responseData.value = {};
    }
  }
}
