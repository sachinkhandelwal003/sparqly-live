import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparqly/app/models/Post_listing_Models/Job_Listing_models.dart';
import 'package:sparqly/app/services/location%20services/Location.dart';

import '../../../services/api_services/apiServices.dart';

class JobsListingsController extends GetxController {
  // ---------- Logo ----------
  var logo = Rxn<File>();

  // ✅ Pick and compress logo
  Future<void> pickCompressedImage() async {
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

      logo.value = File(pickedXFile.path);

      print("✅ Image picked: ${logo.value!.path}");
      print("✅ File size: ${logo.value!.lengthSync() / 1024} KB");
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  // ---------- Form Fields ----------
  var jobTitle = "".obs;
  var companyName = "".obs;
  var location = "".obs;
  var description = "".obs;
  var salary = "".obs;
  var applicationLink = "".obs;

  // ---------- Dropdown (Job Type) ----------
  var jobTypes = <String>[
    "Full-Time",
    "Part-Time",
    "Internship",
    "Contract",
    "Remote",
  ];
  var selectedJobType = Rxn<String>();

  // Api Code

  // Observables
  var isLoading = false.obs;
  var job = Rxn<JobData>();
  var errorMessage = ''.obs;

  // Services
  final ApiServices api = ApiServices();

  final LocationAccesss locationController = Get.find<LocationAccesss>();
  // Text Controllers
  late TextEditingController companyNameController;
  late TextEditingController jobTitleController;
  late TextEditingController jobDescriptionController;
  late TextEditingController salaryRangeController;
  // late TextEditingController locationController;
  late TextEditingController applicationController;
  late TextEditingController mobileVerificationController;

  // Example user id (replace with your logic)
  final String appUserId = "1";

  // ---------------- Create Job API ----------------
  Future<void> createJob(Map<String, dynamic> body, {String? imagePath}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await api.postItem<JobCreateResponse>(
        endpoint: "job/store",
        body: body,
        fromJson: (json) => JobCreateResponse.fromJson(json),
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

        print("\x1B[32m✅ Job created successfully:\x1B[0m");
        print("\x1B[32m${response.data?.toJson()}\x1B[0m");
      } else {
        errorMessage.value = response?.message ?? 'Failed to create job';
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

  // ---------------- Submit Job ----------------
  void submitJob() async {
    // Ensure lat/lng are updated before submitting
    double lat = locationController.latitudeListing.value;
    double lng = locationController.longitudeListing.value;
    final location = locationController.locationController.text.trim();

    final jobTitle = jobTitleController.text.trim();
    final companyName = companyNameController.text.trim();
    //final location = locationController.locationController.text.trim();
    final description = jobDescriptionController.text.trim();
    final salary = salaryRangeController.text.trim();
    final applicationLink = applicationController.text.trim();
    final jobType = selectedJobType.value; // or selectedJobType.value

    // Check fields and show which one is missing
    if (jobTitle.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Job Title");
      return;
    }
    if (companyName.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Company Name");
      return;
    }
    if (location.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Location");
      return;
    }
    if (description.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Description");
      return;
    }
    if (salary.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Salary");
      return;
    }
    if (applicationLink.trim().isEmpty) {
      Get.snackbar("Error", "Please fill the Application Link");
      return;
    }
    if (jobType == null || jobType.trim().isEmpty) {
      Get.snackbar("Error", "Please select the Job Type");
      return;
    }

    try {
      await createJob({
        "app_user_id": appUserId,
        "title": jobTitle,
        "company_name": companyName,
        "job_type": jobType,
        "location": location,
        "latitude": lat,       // ✅ added latitude
        "longitude": lng,      // ✅ added longitude
        "description": description,
        "salary_range": salary,
        "application_link": applicationLink,
        "mobile": mobileVerificationController.text.trim(),
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
  void onInit() {
    super.onInit();
    companyNameController = TextEditingController();
    jobTitleController = TextEditingController();
    jobDescriptionController = TextEditingController();
    salaryRangeController = TextEditingController();
    applicationController = TextEditingController();
    mobileVerificationController = TextEditingController();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    salaryRangeController.dispose();
    //locationController.dispose();
    applicationController.dispose();
    mobileVerificationController.dispose();
    super.onClose();
  }

  // ---------------- ADDITION: helper to get location from LocationAccesss ----------------
  String getSelectedLocation() {
    return locationController.location.value.trim();
  }
}
