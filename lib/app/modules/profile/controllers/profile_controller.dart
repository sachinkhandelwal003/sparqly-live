import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparqly/app/models/Get_Models_All/profile_user_listing_model.dart';
import '../../../models/Get_Models_All/analytics_model.dart';
import '../../../models/Get_Models_All/bookmark_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_services/apiServices.dart';


class ProfileController extends GetxController {
  var selectedTab = 0.obs;

  /// UI observables
  var userId =0.obs;
  var userImage = "".obs;
  var userName = "".obs;
  var userProfession = "".obs;
  var userBio = "".obs;
  var userWebsite = "".obs;


  /// Raw user data (flexible map)
  var userData = {}.obs;

  /// Loading & error state
  var isLoading = false.obs;
  var errorMessage = "".obs;

  /// Optional: base URL if image is relative
  //final String baseUrl = "https://citycross.in/sparqly/storage/";

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    loadBookmarks();
    fetchListings();
    fetchListingViews();
    fetchInvitationPoints();
    loadAnalytics();
  }

  Rx<AnalyticsData?> analyticsData = Rx<AnalyticsData?>(null);
  RxBool isAnalyticsLoading = false.obs;

  Future<void> loadAnalytics() async {
    try {
      isAnalyticsLoading.value = true;

      final response = await ApiServices().fetchAnalytics();
      if (response != null && response.status) {
        analyticsData.value = response.data;
      }
    } finally {
      isAnalyticsLoading.value = false;
    }
  }




  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);
      errorMessage("");

      // ✅ Check internet
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        errorMessage("No internet connection. Please check your network.");
        return;
      }

      final response = await ApiServices().getItem<Map<String, dynamic>>(
        endpoint: "user-profile", // 🔥 Adjust endpoint if needed
        fromJson: (json) => json, // ✅ Keep raw response
      ).timeout(const Duration(seconds: 15));

      if (response != null && response["status"] == true) {
        final data = response["data"] ?? {};

        // ✅ Save full data for debugging
        userData.value = data;

        // 🔎 Debugging logs
        print("✅ Profile raw data: $data");

        // ✅ Map fields safely
        userId.value = data["id"] ?? 0;
        userName.value = data["name"] ?? data["full_name"] ?? "";
        userProfession.value = data["profession"] ?? data["job"] ?? "";
        userBio.value = data["bio"] ?? data["about"] ?? "";
        userWebsite.value = data["website_link"] ?? data["link"] ?? "";

        // ✅ Handle image (add base URL if needed)
        String? imagePath = data["image"] ?? data["profile_pic"];
        if (imagePath != null && imagePath.isNotEmpty) {
          if (imagePath.startsWith("http")) {
            userImage.value = imagePath;
          } else {
          //  userImage.value = "$baseUrl$imagePath";
          }
        } else {
          userImage.value = ""; // fallback
        }
        print("👤 Id: ${userId.value}");
        print("👤 Name: ${userName.value}");
        print("💼 Profession: ${userProfession.value}");
        print("📝 Bio: ${userBio.value}");
        print("🌍 Website: ${userWebsite.value}");
        print("🖼️ Image: ${userImage.value}");
      } else {
        errorMessage(response?["message"] ?? "Failed to fetch profile");
        print("❌ API Error: ${errorMessage.value}");
      }
    } on TimeoutException {
      errorMessage("Request timed out. Please try again.");
    } on FormatException {
      errorMessage("Data format error. Please contact support.");
    } catch (e) {
      errorMessage("Something went wrong: $e");
      print("❌ Profile API error: $e");
    } finally {
      isLoading(false);
    }
  }

  var isLoadingLogout = false.obs;

  Future<void> logout() async {
    try {
      isLoading(true);

      final response = await ApiServices().logoutUser();

      if (response != null && response['status'] == true) {
        print(response['message']); // Success message
        // Clear local storage, token, user session, etc.
      } else {
        print("Logout failed or response null");
      }
    } catch (e) {
      print("Exception during logout: $e");
    } finally {
      isLoading(false);
    }
  }

  // Book Mark Model

  var bookmarks = <BookmarkData>[].obs;
  var isLoadingBookMark = false.obs;


  Future<void> loadBookmarks() async {
    const debugTag = "🔖🟢[Bookmark Controller]";
    try {
      isLoadingBookMark(true);
      // Suppose your API currently returns List<BookmarkItem>
      final response = await ApiServices().fetchBookmarks();
      print("🔖🟢 Full API response: $response");

      if (response != null && response.status) {

        bookmarks.assignAll(response.data.map((item) => item.data).toList()
        );
        print("🔖✅ Bookmarks loaded: ${bookmarks.length}");
      } else {
        bookmarks.clear();
        print("🔖⚠️ No bookmarks found or status false");
      }

    } catch (e, stackTrace) {
      print("$debugTag ❌ Exception: $e");
      print("$debugTag StackTrace: $stackTrace");
    } finally {
      isLoadingBookMark(false);
    }
  }

  var listings = <ProfileListingItem>[].obs;
  var isLoadingProfile = false.obs;
  var errorMessageProfile = ''.obs; // new: holds error messages


  /// Fetch listings from API with proper error handling
  Future<void> fetchListings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print("🔄 Fetching listings from API...");

      final result = await ApiServices().fetchListings();

      if (result != null && result.success) {
        listings.value = result.data;
        print("✅ Listings fetched successfully: ${listings.length} items");
      } else if (result != null && !result.success) {
        listings.clear();
        errorMessage.value = 'API returned success=false';
        print("⚠️ API Response error: ${result}");
      } else {
        listings.clear();
        errorMessage.value = 'No data available';
        print("⚠️ API returned null or empty response");
      }
    } on SocketException catch (e) {
      listings.clear();
      errorMessage.value = 'Network error: Please check your internet connection';
      print("🛑 SocketException: $e");
    } on TimeoutException catch (e) {
      listings.clear();
      errorMessage.value = 'Request timed out. Try again later';
      print("⏱ TimeoutException: $e");
    } on FormatException catch (e) {
      listings.clear();
      errorMessage.value = 'Data format error: Unable to process response';
      print("⚠️ FormatException: $e");
    } on HttpException catch (e) {
      listings.clear();
      errorMessage.value = 'HTTP error: Failed to fetch data';
      print("🛑 HttpException: $e");
    } catch (e, stackTrace) {
      listings.clear();
      errorMessage.value = 'Unexpected error: $e';
      print("❌ Unexpected Exception: $e\nStackTrace:\n$stackTrace");
    } finally {
      isLoading.value = false;
      print("ℹ️ fetchListings completed. isLoading=false");
    }
  }


  var isLoadingInvite = false.obs;
  var messageInvite = ''.obs;
  var inviteMessage = ''.obs;

  Future<void> sendInvite() async {
    try {
      isLoadingInvite.value = true;
      messageInvite.value = '';
      inviteMessage.value = '';

      final response = await ApiServices().sendInvite();

      if (response != null && response['status'] == true) {
        messageInvite.value = response['message'] ?? 'Invite sent successfully';
        inviteMessage.value = response['invite_message'] ?? '';
        print("✅ Invite sent: ${response['invite_message']}");
      } else {
        messageInvite.value = response?['message'] ?? 'Failed to send invite';
        print("❌ API returned failure: ${messageInvite.value}");
      }
    } catch (e) {
      messageInvite.value = "⚠️ Unexpected error: $e";
      print("⚠️ Exception in controller: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // Store API responses as maps
  var listingViews = <String, dynamic>{}.obs;
  var invitationPoints = <String, dynamic>{}.obs;

  // Fetch Listing Views
  Future<void> fetchListingViews() async {
    final response = await ApiServices().getData("analytics/summary");
    if (response != null && response["status"] == true) {
      listingViews.value = response["data"] ?? {};
    }
  }

  // Fetch Invitation Points
  Future<void> fetchInvitationPoints() async {
    final response = await ApiServices().getData("get-invitation-points");
    if (response != null) {
      invitationPoints.value = response;
    }
  }


  var isDeleting = false.obs;

  Future<void> deleteUserAccount() async {
    try {
      isDeleting.value = true;

      final success = await ApiServices().deleteAccount();

      if (success) {
        final storage = GetStorage();
        await storage.erase(); // clears everything including auth_token

        Get.offAllNamed(Routes.OTP); // or Routes.LOGIN

        Get.snackbar(
          "Account Deleted",
          "Your account has been deleted successfully",
        );
      } else {
        Get.snackbar("Error", "Unable to delete account");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isDeleting.value = false;
    }
  }

}
