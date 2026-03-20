import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sparqly/app/models/Post_listing_Models/offer_Listing_models.dart';

import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';

class OffersListingsController extends GetxController {

  late TextEditingController titleController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController couponCodeController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  late TextEditingController latitudeController = TextEditingController();
  late TextEditingController longitudeController = TextEditingController();
  late TextEditingController redemptionInstructionsController = TextEditingController();
  late TextEditingController onlineRedemptionInstructionController = TextEditingController();
  ///final discountTypeController = TextEditingController();
  late TextEditingController originalPriceController = TextEditingController();
  late TextEditingController discountValueController = TextEditingController();
  ///final targetAudienceController = TextEditingController();
  ///final usageLimitController = TextEditingController();
  ///final offerValidityController = TextEditingController();
  late TextEditingController termsConditionsController = TextEditingController();
  late TextEditingController mobileController = TextEditingController();


  // ---------- Offer Image ----------
  var offerImage = Rxn<File>();
  var location = "Mumbai, India".obs;
  var locationType = "all".obs;
  var applicationLink = "".obs;

  void setLocationType(String type) {
    locationType.value = type;
  }


  // ✅ Pick and compress logo
  Future<void> pickOfferImage() async {
    try {
      final picker = ImagePicker();

      // 🔥 compress while picking (no extra package needed)
      final XFile? pickedXFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, // 0 - 100 (lower = smaller file)
        maxWidth: 1024,   // optional resize
        maxHeight: 1024,  // optional resize
      );

      if (pickedXFile == null) return;

      offerImage.value = File(pickedXFile.path);

      print("✅ Image picked: ${offerImage.value!.path}");
      print("✅ File size: ${offerImage.value!.lengthSync() / 1024} KB");
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  // ---------- Form Fields ----------


  var discountType = "".obs;
  var validityDate = "".obs;
  var terms = "".obs;
  var targetAudience = RxnString();
  var usageLimitt = RxnString();

  final targetCategories = [
    "All Customer",
    "New Customers"
  ];
  final usageLimit = [
    "Unlimited uses",
    "One per customer"
  ];

  // ---------- Dropdown Options ----------
  var discountTypes = ["Percentage", "Flat Amount"];

  // ---------- Date Picker ----------
  Future<void> pickDate(context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      validityDate.value = DateFormat("dd MMM yyyy").format(picked);
    }
  }

  // Api Code

  // Observables
  var isLoading = false.obs;
  var job = Rxn<OfferData>();
  var errorMessage = ''.obs;

  // Services
  final ApiServices api = ApiServices();

  // Example user id (replace with your logic)

  // ---------------- Create Job API ----------------
  Future<void> createJob(Map<String, dynamic> body, {String? imagePath}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await api.postItem<OfferResponse>(
        endpoint: "offer/store",
        body: body,
        fromJson: (json) => OfferResponse.fromJson(json),
        imagePath: imagePath,
      );

      if (response != null && response.status == true) {
        job.value = response.data;
        errorMessage.value = '';

        // ✅ Success feedback
        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );

        print("\x1B[32m✅ offer created successfully:\x1B[0m");
        print("\x1B[32m${response.data?.toJson()}\x1B[0m");
      } else {
        errorMessage.value = response?.message ?? 'Failed to create offer';
        print("❌ API Error: ${errorMessage.value}");
      }
    } catch (e, s) {
      errorMessage.value = 'Exception: $e';
      print("❌ Exception in offer controller: $e");
      print("❌ Stacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  void submitOffer() async {
    final LocationAccesss locationController = Get.find<LocationAccesss>();


    final location = locationController.locationController.text.trim();
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    //final redemptionType = redemptionTypeController.text.trim();
    final couponCode = couponCodeController.text.trim();
    final onlineRemptionInstruction = onlineRedemptionInstructionController.text.trim();
    final redemptionInstructions = redemptionInstructionsController.text.trim();
    final originalPrice = originalPriceController.text.trim();
    final discountValue = discountValueController.text.trim();
    final termsConditions = termsConditionsController.text.trim();
    final mobile = mobileController.text.trim();

// ---------- Validation ----------
    if (title.isEmpty) {
      Get.snackbar("Error", "Please enter offer title");
      return;
    }
    if (description.isEmpty) {
      Get.snackbar("Error", "Please enter offer description");
      return;
    }

// couponCode can be optional, but if required:
//     if (couponCode.isEmpty) {
//       Get.snackbar("Error", "Please enter coupon code");
//       return;
//     }
//     if (redemptionInstructions.isEmpty) {
//       Get.snackbar("Error", "Please enter redemption instructions");
//       return;
//     }
    if (location.isEmpty) {
      Get.snackbar("Error", "Please enter location");
      return;
    }
    if (discountType.isEmpty) {
      Get.snackbar("Error", "Please select discount type");
      return;
    }
    if (originalPrice.isEmpty) {
      Get.snackbar("Error", "Please enter original price");
      return;
    }
    if (discountValue.isEmpty) {
      Get.snackbar("Error", "Please enter discount value");
      return;
    }
    if (targetAudience.value == null) {
      Get.snackbar("Error", "Please select target audience");
      return;
    }
    if (usageLimitt.value == null)  {
      Get.snackbar("Error", "Please enter usage limit");
      return;
    }
    if (validityDate.isEmpty) {
      Get.snackbar("Error", "Please enter offer validity date");
      return;
    }
    if (termsConditions.isEmpty) {
      Get.snackbar("Error", "Please enter terms & conditions");
      return;
    }
    if (mobile.isEmpty || mobile.length < 10) {
      Get.snackbar("Error", "Please enter a valid mobile number");
      return;
    }


// Optional URL validation (if not empty)
    bool isValidUrl(String url) {
      final uri = Uri.tryParse(url);
      return uri != null && (uri.isAbsolute);
    }

    // && !isValidUrl(website.value)
    //  if (website.value.isNotEmpty ) {
    //    Get.snackbar("Error", "Please enter a valid website URL");
    //    return;
    //  }


// ---------- If all checks pass, create payload ----------

    try {
      await createJob({
        "title": title,
        "description": description,
        "redemption_type": locationType,
        "coupon_code": couponCode,
        "online_redemption_instructions": onlineRemptionInstruction,
        "location": location,
        "latitude": locationController.latitudeListing,
        "longitude": locationController.longitudeListing,
        "offline_redemption_instructions": redemptionInstructions,
        "discount_type": discountType,
        "original_price": originalPrice,
        "discount_value": discountValue,
        "target_audience": targetAudience,
        "usage_limit": usageLimitt,
        "offer_validity": validityDate,
        "terms_conditions": termsConditions,
        "mobile": mobile,

    }, imagePath: offerImage.value?.path);


      // final title = titleController.text.trim();
      // final description = descriptionController.text.trim();
      // final redemptionType = redemptionTypeController.text.trim();
      // final couponCode = couponCodeController.text.trim();
      // final redemptionInstructions = redemptionInstructionsController.text.trim();
      // final originalPrice = originalPriceController.text.trim();
      // final discountValue = discountValueController.text.trim();
      // //final offerValidity = offerValidityController.text.trim();
      // final termsConditions = termsConditionsController.text.trim();
      // final mobile = mobileController.text.trim();
    } catch (e) {
      Get.snackbar(
        "Exception",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }
  @override
  void onInit() {
    super.onInit();

    // Initialize controllers
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    couponCodeController = TextEditingController();
    onlineRedemptionInstructionController = TextEditingController();
    redemptionInstructionsController = TextEditingController();
    originalPriceController = TextEditingController();
    discountValueController = TextEditingController();
    termsConditionsController = TextEditingController();
    mobileController = TextEditingController();
  }

  @override
  void onClose() {
    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    couponCodeController.dispose();
    onlineRedemptionInstructionController.dispose();
    redemptionInstructionsController.dispose();
    originalPriceController.dispose();
    discountValueController.dispose();
    termsConditionsController.dispose();
    mobileController.dispose();

    super.onClose();
  }
}