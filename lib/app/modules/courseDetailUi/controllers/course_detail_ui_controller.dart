import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/Get_Models_All/All_Detail_ui_models/course_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../courses/controllers/courses_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class CourseDetailUiController extends GetxController {

  final CoursesController coursesController = Get.find<CoursesController>();
  var isExpanded = false.obs; // default collapsed
  var isLoading = false.obs;
  var courseDetail = Rxn<CourseDetailPageModel>();
  var errorMessage = "".obs;
  late Razorpay _razorpay;
  var razorpayKey = ''.obs;
  String? _razorpayOrderId;
  int? _payingCourseId;


  final ApiServices _apiServices = ApiServices();

  void fetchCourseDetail(int courseId) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final token = GetStorage().read('auth_token') ?? "";

      if (token.isEmpty) {
        errorMessage.value = "Authentication token not found.";
        print("Error: Auth token is missing in GetStorage.");
        return;
      }

      final result = await _apiServices.fetchCourseDetail(courseId, token);

      if (result != null) {
        if (result.status) {
          courseDetail.value = result;
          print("Course fetched successfully: ${result.data.courseTitle}");

          callPostApi(
            data: {
              "data_id": courseId,
              "data_type": "course",
              "list_creator_id": courseDetail.value?.data.UserId ?? 0,
            },
          );
        } else {
          errorMessage.value = result.message;
          print("API returned status=false: ${result.message}");
        }
      } else {
        errorMessage.value = "Failed to fetch course data.";
        print("Error: Result is null. Check API response or network.");
      }
    } catch (e, stacktrace) {
      errorMessage.value = "Something went wrong: $e";
      print("Exception in fetchCourseDetail controller: $e");
      print("Stacktrace: $stacktrace");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onInit() {
    super.onInit();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    loadRazorpayKeys();
    // Fetch immediately if selectedId already has a value
    final currentId = coursesController.selectedId.value;
    if (currentId != 0) {
      print("🔄 Fetching course for initial selectedId: $currentId");
      fetchCourseDetail(currentId);
    }

    // Also react to future changes
    ever<int>(coursesController.selectedId, (id) {
      print("🔄 SelectedId changed: $id");
      fetchCourseDetail(id);
    });
  }

  // Load Razorpay keys
  Future<void> loadRazorpayKeys() async {
    final keys = await ApiServices().fetchRazorpayKeys();
    if (keys != null) razorpayKey.value = keys["key"] ?? "";
  }

  void startCoursePayment({
    required CourseDetailData course,
  }) async {
    if (razorpayKey.value.isEmpty) {
      Get.snackbar("Error", "Payment key not loaded");
      return;
    }

    try {
      isLoading.value = true;
      _payingCourseId = course.id;

      print("🧾 Creating order for courseId: ${course.id}");

      final orderRes =
      await _apiServices.createCourseOrder(course.id);

      if (orderRes == null || orderRes["status"] != true) {
        Get.snackbar("Error", "Failed to create order");
        return;
      }

      // ✅ READ DIRECTLY (NO data KEY)
      final String orderId = orderRes["order_id"];
      final int amount = orderRes["amount"];
      final String key = orderRes["razorpay_key"];

      print("✅ Order created → $orderId | Amount: ₹${amount / 100}");

      var options = {
        'key': key,
        'amount': amount, // already in paise
        'currency': 'INR',
        'order_id': orderId,
        'name': 'Course Purchase',
        'description': course.courseTitle,
        'prefill': {
          'contact': '9999999999',
          'email': 'test@example.com',
        },
        'theme': {
          'color': '#3399cc',
        },
      };

      _razorpay.open(options);
    } catch (e) {
      print("💥 Payment Start Error: $e");
      Get.snackbar("Payment Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }





  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      print("✅ PAYMENT SUCCESS");
      print("paymentId: ${response.paymentId}");
      print("orderId: ${response.orderId}");
      print("signature: ${response.signature}");

      final verifyRes = await _apiServices.verifyCoursePayment(
        razorpayPaymentId: response.paymentId!,
        razorpayOrderId: response.orderId!,
        razorpaySignature: response.signature!,
      );

      if (verifyRes != null && verifyRes["status"] == true) {
        Get.snackbar(
          "Payment Successful",
          "Your course has been unlocked 🎉",
          snackPosition: SnackPosition.BOTTOM,
        );

        // 🔄 Refresh course data (unlock UI / curriculum)
        if (_payingCourseId != null) {
          fetchCourseDetail(_payingCourseId!);
        }
      } else {
        Get.snackbar(
          "Verification Failed",
          verifyRes?["message"] ?? "Payment verification failed",
        );
      }
    } catch (e) {
      print("💥 Payment Verification Error: $e");
      Get.snackbar("Error", "Payment verification failed");
    }
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ PAYMENT FAILED: ${response.code} | ${response.message}");

    Get.snackbar(
      "Payment Failed",
      response.message ?? "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
    );
  }


  void _handleExternalWallet(ExternalWalletResponse response) {
    print("💼 EXTERNAL WALLET: ${response.walletName}");
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
  fetchReviewsInfluencer() async {
    try {
      isLoadingReview(true);
      errorMessageReview("");

      print("📤 Starting fetchReviews for job_id: ${coursesController.selectedId.value}");

      final data = await ApiServices().fetchReviewData(
        endpoint: "course/get-reviews",
        idKey: "course_id",
        idValue: coursesController.selectedId.value,
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
    const endpoint = "course/review/store";    // your API endpoint
    const idField = "course_id";              // the field name for business ID
    final int idValue = coursesController.selectedId.value; // current business ID

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
            (sum, r) =>
        sum + (int.tryParse(r['rating']?.toString() ?? '0') ?? 0),
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


  @override
  void onClose() {
    _razorpay.clear(); // VERY IMPORTANT
    super.onClose();
  }


}
