import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_services/apiServices.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  // All text controllers
  final businessNameController = TextEditingController();
  final professionController = TextEditingController();
  final bioController = TextEditingController();
  final websiteController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final talukaController = TextEditingController();
  // Gender dropdown options
  final genderList = ["Male", "Female", "Prefer not to say"];

// Selected gender
  var selectedGender = RxnString();



  /// Progress of filled fields
  var progress = 0.0.obs;

  /// Local profile picture (picked from device)
  var profilePic = Rxn<File>();

  /// Server image URL (from API response)
  var profileImageUrl = "".obs;

  /// Total fields (6 text + 1 pic)
  final int totalFields = 9;


  var isLoading = false.obs;
  var userData = {}.obs;
  var errorMessage = "".obs;

  // State & District dropdown data
  var states = <dynamic>[].obs;
  var districts = <dynamic>[].obs;

// Selected values
  var selectedStateId = RxnInt();
  var selectedDistrictId = RxnInt();

// Loading flags
  var isStateLoading = false.obs;
  var isDistrictLoading = false.obs;



  @override
  void onInit() {
    super.onInit();


    loadStates();
    // Add listeners to update progress dynamically
    businessNameController.addListener(updateProgress);
    professionController.addListener(updateProgress);
    bioController.addListener(updateProgress);
    websiteController.addListener(updateProgress);
    phoneController.addListener(updateProgress);
    emailController.addListener(updateProgress);
  }

  /// Update progress bar based on filled fields
  void updateProgress() {
    int filled = 0;
    if (businessNameController.text.trim().isNotEmpty) filled++;
    if (professionController.text.trim().isNotEmpty) filled++;
    if (bioController.text.trim().isNotEmpty) filled++;
    if (websiteController.text.trim().isNotEmpty) filled++;
    if (talukaController.text.trim().isNotEmpty) filled++;
    if (phoneController.text.trim().isNotEmpty) filled++;
    if (emailController.text.trim().isNotEmpty) filled++;
    if (selectedGender.value != null) filled++;
    if (profilePic.value != null) filled++;

    progress.value = filled / totalFields;
  }



  /// Validation
  bool validateFields() {
    if (businessNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Display Name is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CupertinoColors.systemRed);
      return false;
    }

    if (professionController.text.trim().isEmpty) {
      Get.snackbar("Error", "Profession is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CupertinoColors.systemRed);
      return false;
    }

    if (phoneController.text.trim().isEmpty ||
        phoneController.text.trim().length < 10) {
      Get.snackbar("Error", "Valid Mobile Number is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CupertinoColors.systemRed);
      return false;
    }

    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Valid Email is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CupertinoColors.systemRed);
      return false;
    }

    return true;
  }

  /// Save button
  Future<void> saveProfile() async {
    if (!validateFields()) return;

    final body = {
      "name": businessNameController.text.trim(),
      "profession": professionController.text.trim(),
      "gender": selectedGender.value,
      "bio": bioController.text.trim(),
      "email": emailController.text.trim(),
      "mobile": phoneController.text.trim(),

      "state": selectedStateName,
      "city": selectedDistrictName,
      "taluka": talukaController.text.trim(),

      "website_link": websiteController.text.trim(),
    };



    await updateProfile(body, imagePath: profilePic.value?.path);

    // 🔥 Refresh ProfileController after update
    final profileCtrl = Get.find<ProfileController>();
    await profileCtrl.fetchUserProfile();
  }

  /// Pick profile picture
  Future<void> pickProfilePic() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedXFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedXFile == null) return;

      profilePic.value = File(pickedXFile.path);
      updateProgress();
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  /// Update Profile API Call
  Future<void> updateProfile(Map<String, dynamic> body,
      {String? imagePath}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiServices().postItem(
        endpoint: "update/profile",
        body: body,
        imagePath: imagePath,
        fromJson: (json) => json,
      );

      if (response != null && response["status"] == true) {
        userData.value = response["data"] ?? {};
        errorMessage.value = '';

        // ✅ Save API image URL
        profileImageUrl.value = userData["image"] ?? "";

        Get.snackbar("Success", response["message"] ?? "Updated successfully",
            snackPosition: SnackPosition.BOTTOM);

        print("✅ Profile updated successfully:");
        print(userData);

        // ❌ Do not clear profilePic here
       //  clearTextFields();
      } else {
        errorMessage.value =
            response?["message"] ?? 'Failed to update profile';
        print("❌ API Error: ${errorMessage.value}");
      }
    } catch (e, s) {
      errorMessage.value = 'Exception: $e';
      print("❌ Exception in controller: $e");
      print("❌ Stacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStates() async {
    try {
      isStateLoading.value = true;
      final data = await ApiServices().fetchStates();
      states.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load states");
    } finally {
      isStateLoading.value = false;
    }
  }

  Future<void> loadDistricts(int stateId) async {
    try {
      isDistrictLoading.value = true;
      districts.clear();
      selectedDistrictId.value = null;

      final data = await ApiServices().fetchDistricts(stateId);
      districts.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to load districts");
    } finally {
      isDistrictLoading.value = false;
    }
  }

  String? get selectedStateName {
    final state = states.firstWhereOrNull(
          (e) => e['id'] == selectedStateId.value,
    );
    return state?['name'];
  }

  String? get selectedDistrictName {
    final district = districts.firstWhereOrNull(
          (e) => e['id'] == selectedDistrictId.value,
    );
    return district?['name'];
  }



  /// Optional: clear text fields only (not images)
  void clearTextFields() {
    talukaController.clear();
    selectedGender.value = null;
    selectedStateId.value = null;
    selectedDistrictId.value = null;

    businessNameController.clear();
    professionController.clear();
    bioController.clear();
    websiteController.clear();
    phoneController.clear();
    emailController.clear();
    progress.value = 0.0;
  }

  @override
  void onClose() {
    businessNameController.dispose();
    professionController.dispose();
    bioController.dispose();
    websiteController.dispose();
    talukaController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

}
