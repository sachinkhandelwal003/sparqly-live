import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sparqly/app/modules/home/controllers/home_controller.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import '../../../models/Get_Models_All/adOfferPrice.dart';
import '../../../models/Post_listing_Models/Ad_Listing_model.dart';
import '../../../services/location services/Location.dart';

class AdListingsController extends GetxController {

  final HomeController homeController = Get.put(HomeController());
  final adTitleNameController = TextEditingController();
  final sponsorNameController = TextEditingController();
  final ctaButtonController = TextEditingController();
  final ctaLinkController = TextEditingController();
  final mobileController = TextEditingController();
  String? currentRazorpayOrderId;


  var logo = Rx<File?>(null);
  final LocationAccesss locationController = Get.find<LocationAccesss>();
  final ApiServices api = ApiServices();

  late Razorpay razorpay;


  var selectedDays = 1.obs;
  var totalPrice = 0.obs;
  var campaignType = "".obs;
  var status = "Draft".obs;
  var targetingTypeLocation = "all".obs;
  var startDate = "".obs;
  var endDate = "".obs;
  var selectedListing = "".obs;
  var selectedListingId = 0.obs;

  var isLoading = false.obs;
  var isLoadingUserListing = true.obs;
  var errorMessage = "".obs;
  var userListingsUserListing = <AdUserListing>[].obs;
  var offerPrices = <OfferPrice>[].obs;
  var pricePerDay = 0.obs;

  var ad = Rxn<AdvertisementData>();

  List<String> campaignTypes = ["Boosted Ad", "Sponsored Ad"];
  List<String> statuses = ["Draft", "Active", "Paused", "Completed"];

  void setDays(int days) {
    selectedDays.value = days;
    calculatePrice();
  }

  Future<void> pickCompressedImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedXFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedXFile == null) return;
      logo.value = File(pickedXFile.path);
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void calculatePrice() {
    if (offerPrices.isEmpty || campaignType.value.isEmpty) {
      totalPrice.value = 0;
      return;
    }

    final offerType = campaignType.value == "Boosted Ad"
        ? "Boosted"
        : "Advertisement";

    final targetType = targetingTypeLocation.value == "all"
        ? "All Users"
        : "Specific Location";

    final matchedPrice = offerPrices.firstWhereOrNull(
          (e) =>
      e.offerType == offerType &&
          e.targetType == targetType,
    );

    pricePerDay.value = matchedPrice?.pricePerDay ?? 0;
    totalPrice.value = pricePerDay.value * selectedDays.value;
  }

  Future<void> pickStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) startDate.value = pickedDate.toIso8601String().split("T").first;
  }

  Future<void> pickEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) endDate.value = pickedDate.toIso8601String().split("T").first;
  }

  void submitAd() {
    if (campaignType.value.isEmpty) {
      _showError("Please select Ad Type");
      return;
    }
    if (campaignType.value != "Boosted Ad" && adTitleNameController.text.trim().isEmpty) {
      _showError("Please enter Title");
      return;
    }
    if (campaignType.value != "Boosted Ad" && sponsorNameController.text.trim().isEmpty) {
      _showError("Please enter Sponsor Name");
      return;
    }
    if (ctaLinkController.text.trim().isEmpty) {
      _showError("Please enter CTA Link");
      return;
    }
    if (selectedDays.value == 0) {
      _showError("Please enter Promotion Days");
      return;
    }
    if (startDate.value.isEmpty || endDate.value.isEmpty) {
      _showError("Please select Start and End Dates");
      return;
    }
    startPayment();
  }

  void _showError(String message) {
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white);
  }

  Future<void> startPayment() async {
    final order = await api.createAdRazorpayOrder(
      amount: totalPrice.value, // rupees
    );

    if (order == null) {
      _showError("Failed to create Razorpay order");
      return;
    }

    currentRazorpayOrderId = order["order_id"];
    print("🔥 Backend Order ID → $currentRazorpayOrderId");

    var options = {
      'key': order["key"],
      'order_id': order["order_id"], // MUST MATCH BACKEND
      'amount': order["amount"],     // paise
      'name': 'Ad Campaign Payment',
      'description': 'Payment for Sponsored Ad',
      'prefill': {
        'contact': mobileController.text.trim(),
        'email': 'test@gmail.com',
      },
    };

    razorpay.open(options); // ✅ ONLY ONCE
  }



  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("🔥 Razorpay Returned Order ID → ${response.orderId}");

    if (response.orderId != currentRazorpayOrderId) {
      print("❌ ORDER ID MISMATCH — ABORTING");
      _showError("Payment verification failed");
      return;
    }
    print("🎉 Payment Success: ${response.paymentId}");
    print("✅ paymentId → ${response.paymentId}");
    print("✅ orderId → ${response.orderId}");
    print("✅ signature → ${response.signature}");
    // Submit ad with Razorpay info
    Map<String, dynamic> adBody = {
      "title": adTitleNameController.text.trim(),
      "sponsor_name": sponsorNameController.text.trim(),
      "ad_type": campaignType.value,
      "user_listing_id": selectedListingId.value == 0 ? null : selectedListingId.value,
      "user_listing_name": selectedListing.value.isEmpty ? null : selectedListing.value,
      "ad_status": status.value,
      "targeting_type": targetingTypeLocation.value,
      "location": locationController.locationController.text.trim().isEmpty ? null : locationController.locationController.text.trim(),
      "latitude": locationController.latitudeListing.value == 0.0 ? null : locationController.latitudeListing.value,
      "longitude": locationController.longitudeListing.value == 0.0 ? null : locationController.longitudeListing.value,
      "start_date": startDate.value,
      "end_date": endDate.value,
      "cta_button": ctaButtonController.text.trim(),
      "cta_link": ctaLinkController.text.trim(),
      "promotion_days": selectedDays.value,
      "total_price": totalPrice.value,
      "mobile": mobileController.text.trim(),
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature,
    };

    await createAd(adBody, imagePath: logo.value?.path);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", "Transaction failed, try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }


  Future<void> createAd(Map<String, dynamic> body, {String? imagePath}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 🔍 Debug: Check all fields before sending
      print("📦 Preparing Ad data for submission:");
      body.forEach((key, value) {
        if (value == null || (value is String && value.trim().isEmpty)) {
          print("⚠️ $key → NULL or EMPTY");
        } else {
          print("✅ $key → $value");
        }
      });

      if (imagePath == null || imagePath.isEmpty) {
        print("⚠️ No image selected");
      } else {
        print("📷 Image path: $imagePath");
      }

      // Send API request
      final response = await api.postItem<AdvertisementResponse>(
        endpoint: "advertisement/store",
        body: body,
        fromJson: (json) => AdvertisementResponse.fromJson(json),
        imagePath: imagePath,
      );

      if (response != null && response.status) {
        ad.value = response.data;
        errorMessage.value = '';
        print("\x1B[32m✅ Ad created successfully: ${response.data?.toJson()}\x1B[0m");

        Get.snackbar("Success", response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white);

        await homeController.fetchHeroSections();
        resetFields();
      } else {
        errorMessage.value = response?.message ?? 'Failed to create Ad';
        print("❌ API Error: ${errorMessage.value}");
      }
    } catch (e, s) {
      errorMessage.value = 'Exception: $e';
      print("❌ Exception in Ad's controller: $e");
      print("❌ Stacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields() {
    adTitleNameController.clear();
    sponsorNameController.clear();
    ctaButtonController.text = "Sponsored";
    ctaLinkController.clear();
    mobileController.clear();
    logo.value = null;
    selectedDays.value = 1;
    totalPrice.value = 0;
    campaignType.value = "";
    status.value = "Draft";
    startDate.value = "";
    endDate.value = "";
    selectedListing.value = "";
    selectedListingId.value = 0;
    targetingTypeLocation.value = "all";
  }

  void fetchUserListings() async {
    try {
      isLoadingUserListing(true);
      errorMessage.value = "";

      var response = await ApiServices().fetchUserListings();

      if (response != null) {
        if (response.status) {
          userListingsUserListing.value = response.data.isNotEmpty ? response.data : [];
          errorMessage.value = response.data.isEmpty ? "No listings found." : "";
        } else {
          userListingsUserListing.clear();
          errorMessage.value = response.message.isNotEmpty ? response.message : "Something went wrong!";
        }
      } else {
        userListingsUserListing.clear();
        errorMessage.value = "Failed to fetch data. Please try again.";
      }
    } catch (e) {
      userListingsUserListing.clear();
      errorMessage.value = "Error: $e";
      print("Exception in fetchUserListings: $e");
    } finally {
      isLoadingUserListing(false);
    }
  }

  void fetchOfferPrices() async {
    offerPrices.value = await api.fetchOfferPrices();
    calculatePrice();
  }


  @override
  void onInit() {
    super.onInit();

    fetchOfferPrices();
    fetchUserListings();

    ever(campaignType, (_) => calculatePrice());
    ever(targetingTypeLocation, (_) => calculatePrice());
    ever(selectedDays, (_) => calculatePrice());
    ever(offerPrices, (_) => calculatePrice());

    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }



  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }
}
