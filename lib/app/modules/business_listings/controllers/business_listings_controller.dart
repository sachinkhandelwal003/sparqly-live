import 'dart:io';
import 'dart:ui' as img;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../models/Post_listing_Models/Business_Listing_model.dart';
import '../../../models/Post_listing_Models/category_Models.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';
import '../../business/controllers/business_controller.dart';

class BusinessListingsController extends GetxController {

  var logo = Rx<File?>(null);
  var businessName = "".obs;
  var shortDescription = "".obs;
  var fullDescription = "".obs;
  var location = "Mumbai, India".obs;
  var website = "https://example.com".obs;
  var startingPrice = "".obs;
  var mobileVerification = "".obs;
  final LocationAccesss locationController = Get.find<LocationAccesss>();
  final subscription = Rxn<SubscriptionPlanActive>();

  late TextEditingController businessController;
  late TextEditingController shortDescriptionController;
  late TextEditingController fullDescriptionController;
  late TextEditingController websiteController;
  late TextEditingController startingPriceController;
  late TextEditingController mobileVerificationController;

  GoogleMapController? mapController;
  double minZoom = 5;
  double maxZoom = 18;
  var latitude = 19.0760.obs;
  var longitude = 72.8777.obs;

  var isLoading = false.obs;
  var business = Rxn<Business>();
  var errorMessage = ''.obs;
  final ApiServices api = ApiServices();
  final _categoryService = ApiServices();

  @override
  void onInit() {
    super.onInit();
    businessController = TextEditingController();
    shortDescriptionController = TextEditingController();
    fullDescriptionController = TextEditingController();
    websiteController = TextEditingController(text: website.value);
    startingPriceController = TextEditingController();
    mobileVerificationController = TextEditingController();
    fetchCategories();
  }

  var selectedCategory = Rxn<CategoryDropdown>();
  var categories = <CategoryDropdown>[].obs;
  var hasError = false.obs;

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final jsonData = await _categoryService.getRequest("/business/get_business_category");

      if (jsonData is Map && jsonData.containsKey("data")) {
        final List dataList = jsonData["data"];
        categories.assignAll(
          dataList.map((e) => CategoryDropdown.fromJson(e)).toList(),
        );
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
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
      print(" Error picking image: $e");
    }
  }

  Future<void> loadSubscription() async {
    try {
      isLoading.value = true;

      subscription.value = await api.fetchSubscriptionPlan();

    } catch (e) {
      Get.snackbar(
        "Subscription Error",
        e.toString().replaceAll("Exception:", "").trim(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createBusiness(
      Map<String, dynamic> body, {
        String? imagePath,
      }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiServices().postItem<BusinessListingModel>(
        endpoint: "business/store",
        body: body,
        fromJson: (json) => BusinessListingModel.fromJson(json),
        imagePath: imagePath ?? logo.value?.path,
      );

      if (response != null && response.status == true) {
        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );

        final businessController = Get.find<BusinessController>();
        await businessController.fetchBusinesses();
        return;
      }

      errorMessage.value =
          response?.message ?? "Failed to create business";

      Get.snackbar(
        "Action Failed",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );

    } catch (e, s) {
      final message = e
          .toString()
          .replaceAll("Exception:", "")
          .trim();

      errorMessage.value =
      message.isNotEmpty ? message : "Failed to create business";

      Get.snackbar(
        "Action Failed",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void submitBusiness() async {
    final loc = locationController.locationController.text.trim();
    final lat = locationController.latitudeListing.value;
    final lng = locationController.longitudeListing.value;
    final name = businessController.text.trim();
    final shortDesc = shortDescriptionController.text.trim();
    final fullDesc = fullDescriptionController.text.trim();
    final web = websiteController.text.trim();
    final price = startingPriceController.text.trim();
    final mobile = mobileVerificationController.text.trim();
    final category = selectedCategory.value?.id.toString();
    if (name.isEmpty) {
      Get.snackbar("Error", "Please fill the Business Name");
      return;
    }
    if (shortDesc.isEmpty) {
      Get.snackbar("Error", "Please fill the Short Description");
      return;
    }
    if (fullDesc.isEmpty) {
      Get.snackbar("Error", "Please fill the Full Description");
      return;
    }
    if (loc.isEmpty) {
      Get.snackbar("Error", "Please fill the Location");
      return;
    }
    if (web.isEmpty) {
      Get.snackbar("Error", "Please fill the Website");
      return;
    }
    if (price.isEmpty) {
      Get.snackbar("Error", "Please fill the Starting Price");
      return;
    }
    if (mobile.isEmpty) {
      Get.snackbar("Error", "Please fill the Mobile Number");
      return;
    }
    if (category == null || category.isEmpty) {
      Get.snackbar("Error", "Please select a Category");
      return;
    }
    try {
      await createBusiness({
        "name": name,
        "short_desc": shortDesc,
        "description": fullDesc,
        "location": loc,
        "latitude": lat,
        "longitude": lng,
        "website_link": web,
        "price": price,
        "mobile": mobile,
        "business_cat_id": category,
      }, imagePath: logo.value?.path);
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
  void onClose() {
    businessController.dispose();
    shortDescriptionController.dispose();
    fullDescriptionController.dispose();
    locationController.dispose();
    websiteController.dispose();
    startingPriceController.dispose();
    mobileVerificationController.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
