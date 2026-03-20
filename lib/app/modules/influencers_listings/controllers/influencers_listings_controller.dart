import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparqly/app/models/Post_listing_Models/influencer_Listing_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../services/location services/Location.dart';

class InfluencersListingsController extends GetxController {
  var applicationLink = "".obs;
  late TextEditingController nameController;
  late TextEditingController professionController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  late TextEditingController nicheController;
  late TextEditingController mobileVerificationController;
  final _categoryService = ApiServices();


  // ---------- Profile Picture ----------
  var profilePic = Rxn<File>();

  // ✅ Pick and compress logo
  Future<void> pickProfilePic() async {
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

      profilePic.value = File(pickedXFile.path);

      print("✅ Image picked: ${profilePic.value!.path}");
      print("✅ File size: ${profilePic.value!.lengthSync() / 1024} KB");
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  var hasError = false.obs;
  var isLoadingCategory = false.obs;
  // Controller variables
  var selectedCategory = Rxn<CategoryInfluencer>();
  var categories = <CategoryInfluencer>[].obs;

// Fetch categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final jsonData = await _categoryService.getRequest("/get-influencer-category");

      if (jsonData is Map && jsonData.containsKey("data")) {
        final dataList = List<Map<String, dynamic>>.from(jsonData["data"]);
        categories.assignAll(
          dataList.map((e) => CategoryInfluencer.fromJson(e)).toList(),
        );
        print("✅ Fetched categories: ${categories.length}");
      } else {
        print("⚠️ Unexpected response format: $jsonData");
        hasError.value = true;
      }

    } catch (e) {
      print("❌ Failed to load categories: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }



  // ---------- Form Fields ----------
  var name = "".obs;
  var profession = "".obs;
  var bio = "".obs;
  var niche = "".obs;
  var website = "".obs;

  // ---------- Dropdown Options ----------
  var followerRanges = <String>[
    "0 - 1K",
    "1K - 10K",
    "10K - 50K",
    "50K - 100K",
    "100K - 500K",
    "500K+"
  ];

  var instagramFollowers = Rxn<String>();
  var youtubeFollowers = Rxn<String>();
  var facebookFollowers = Rxn<String>();
  var linkedinFollowers = Rxn<String>();


  // Api Code

  // Observables
  var isLoading = false.obs;
  var job = Rxn<InfluencerData>();
  var errorMessage = ''.obs;

  // Services
  final ApiServices api = ApiServices();

  // Example user id (replace with your logic)

  // ---------------- Create Job API ----------------
  Future<void> createInfluencer(Map<String, dynamic> body, {String? imagePath}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await api.postItem<InfluencerResponse>(
        endpoint: "influencer/store",
        body: body,
        fromJson: (json) => InfluencerResponse.fromJson(json),
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

        print("\x1B[32m✅ Influencer created successfully:\x1B[0m");
        print("\x1B[32m${response.data?.toJson()}\x1B[0m");
      } else {
        errorMessage.value = response?.message ?? 'Failed to create Influencer';
        print("❌ API Error: ${errorMessage.value}");
      }
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

      print("❌ Exception: $e");
      print("❌ Stacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  void submitProfile() async {
    final LocationAccesss locationController = Get.find<LocationAccesss>();

    double lat = locationController.latitudeListing.value;
    double lng = locationController.longitudeListing.value;
    final location = locationController.locationController.text.trim();
    final name = nameController.text.trim();
    final profession = professionController.text.trim();
    final bio = bioController.text.trim();
    //final niche = nicheController.text.trim();
    final mobile = mobileVerificationController.text.trim();
    final category = selectedCategory.value?.id.toString();

// ---------- Validation ----------
    if (name.isEmpty) {
      Get.snackbar("Error", "Please enter your name");
      return;
    }
    if (profession.isEmpty) {
      Get.snackbar("Error", "Please enter your profession");
      return;
    }
    if (bio.isEmpty) {
      Get.snackbar("Error", "Please enter your bio");
      return;
    }
    if (category == null || category.isEmpty) {
      Get.snackbar("Error", "Please select a Category");
      return;
    }
    if (location.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Location");
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
    if (instagramFollowers.value == null) {
      Get.snackbar("Error", "Please enter a valid Instagram URL");
      return;
    }
    if (youtubeFollowers.value == null) {
      Get.snackbar("Error", "Please enter a valid YouTube URL");
      return;
    }
    if (facebookFollowers.value == null) {
      Get.snackbar("Error", "Please enter a valid Facebook URL");
      return;
    }
    if (linkedinFollowers.value == null) {
      Get.snackbar("Error", "Please enter a valid LinkedIn URL");
      return;
    }

// ---------- If all checks pass, create payload ----------

    try {
      await createInfluencer({
        "name": name,
        "profession": profession,
        "bio": bio,
        "niche": category,
        "location": location,
        "latitude": lat,       // ✅ added latitude
        "longitude": lng,
        "website_link": website,
        "instagram": instagramFollowers,
        "youtube": youtubeFollowers,
        "facebook": facebookFollowers,
        "linkedin": linkedinFollowers,
        "mobile": mobile,
      }, imagePath: profilePic.value?.path);
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

    nameController = TextEditingController();
    professionController = TextEditingController();
    bioController = TextEditingController();
    locationController = TextEditingController();
    nicheController = TextEditingController();
    mobileVerificationController = TextEditingController();
    fetchCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    professionController.dispose();
    bioController.dispose();
    locationController.dispose();
    nicheController.dispose();
    mobileVerificationController.dispose();
    super.onClose();
  }

}
