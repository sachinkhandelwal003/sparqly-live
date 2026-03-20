import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparqly/app/link_controller.dart';
import 'package:sparqly/app/modules/business/controllers/business_controller.dart';
import 'package:sparqly/app/modules/courses/controllers/courses_controller.dart';
import 'package:sparqly/app/modules/influencers/controllers/influencers_controller.dart';
import 'package:sparqly/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:sparqly/app/modules/offers/controllers/offers_controller.dart';
import 'package:sparqly/app/modules/referal/views/referal_view.dart';
import '../../../services/location services/Location.dart';
import '../../ad_listings/views/ad_listings_view.dart';
import '../../business/views/business_view.dart';
import '../../business_detail_page/views/business_detail_page_view.dart';
import '../../business_listings/views/business_listings_view.dart';
import '../../categories/views/categories_view.dart';
import '../../chat/views/chatList.dart';
import '../../chat/views/chat_view.dart';
import '../../courseDetailUi/views/course_detail_ui_view.dart';
import '../../course_listings/views/course_listings_view.dart';
import '../../courses/views/courses_view.dart';
import '../../create/views/create_view.dart';
import '../../edit_profile/views/edit_profile_view.dart';
import '../../home/views/home_view.dart';
import '../../influencer_detail_page/views/influencer_detail_page_view.dart';
import '../../influencers/views/influencers_view.dart';
import '../../influencers_listings/views/influencers_listings_view.dart';
import '../../jobs/views/jobs_view.dart';
import '../../jobs_detail_page/views/jobs_detail_page_view.dart';
import '../../jobs_listings/views/jobs_listings_view.dart';
import '../../offers/views/offers_view.dart';
import '../../offers_detail_page/views/offers_detail_page_view.dart';
import '../../offers_listings/views/offers_listings_view.dart';
import '../../profile/views/profile_view.dart';
import 'package:sparqly/app/routes/app_pages.dart';
import '../../subscription/views/subscription_view.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var currentArgs = Rx<dynamic>(null);

  final storage = GetStorage();

  /// ✅ Restricted indexes (require login)
  final List<int> restrictedIndexes = [
    5, // BusinessListings
    6, // JobsListings
    7, // InfluencersListings
    8, // CourseListings
    9, // OffersListings
    10, // AdListings
    14, // Profile
    15, // ChatList
    16, // ChatView
    17, // BusinessDetail
    18, // JobsDetail
    19, // InfluencerDetail
    20, // OffersDetail
    21, // CourseDetail
    22, // EditProfile
  ];

  /// ✅ All pages
  final List<Widget Function()> pages = [
    () => HomeView(), // 0
    () => CategoriesView(), // 1
    () => CreateView(), // 2
    () => OffersView(), // 3
    () => CoursesView(), // 4
    () => BusinessListingsView(), // 5
    () => JobsListingsView(), // 6
    () => InfluencersListingsView(), // 7
    () => CourseListingsView(), // 8
    () => OffersListingsView(), // 9
    () => AdListingsView(), // 10
    () => BusinessView(), // 11
    () => JobsView(), // 12
    () => InfluencersView(), // 13
    () => ProfileView(), // 14
    () => ChatListScreen(), // 15
    () => ChatView(), // 16
    () => BusinessDetailPageView(), // 17
    () => JobsDetailPageView(), // 18
    () => InfluencerDetailPageView(), // 19
    () => OffersDetailPageView(), // 20
    () => CourseDetailView(), // 21
    () => EditProfileView(), // 22
    () => SubscriptionView(), // 23
    () => ReferalView(), // 24
  ];

  /// ✅ Navigation logic with auto-dispose
  // void goToPage(int index, {dynamic args}) {
  //   currentArgs.value = args;

  //   final token = storage.read('auth_token');
  //   final isGuest = storage.read('is_guest') == true;

  //   // Restrict guest users
  //   if (restrictedIndexes.contains(index) &&
  //       (token == null || token.toString().isEmpty)) {
  //     print(
  //       "⚠️ Restricted index $index, no token found. Redirecting to OTP...",
  //     );
  //     Get.toNamed(Routes.OTP);
  //     return;
  //   }

  //   final oldIndex = selectedIndex.value;

  //   // ✅ Dispose controller of old page if it was restricted
  //   if (restrictedIndexes.contains(oldIndex) && oldIndex != index) {
  //     Get.delete(force: true);
  //     print("Disposed controllers from index $oldIndex ✅");
  //   }

  //   selectedIndex.value = index;
  // }

  void goToPage(int index, {dynamic args}) {
    currentArgs.value = args;

    final token = storage.read('auth_token');

    if (restrictedIndexes.contains(index) &&
        (token == null || token.toString().isEmpty)) {
      Get.toNamed(Routes.OTP);
      return;
    }

    final oldIndex = selectedIndex.value;

    // 👇 YAHI PE LAGANA HAI
    if (restrictedIndexes.contains(oldIndex) && oldIndex != index) {
      switch (oldIndex) {
        case 17:
          if (Get.isRegistered<BusinessController>()) {
            Get.delete<BusinessController>();
          }
          break;

        case 18:
          if (Get.isRegistered<JobsController>()) {
            Get.delete<JobsController>();
          }
          break;

        case 19:
          if (Get.isRegistered<InfluencersController>()) {
            Get.delete<InfluencersController>();
          }
          break;

        case 20:
          if (Get.isRegistered<OffersController>()) {
            Get.delete<OffersController>();
          }
          break;

        case 21:
          if (Get.isRegistered<CoursesController>()) {
            Get.delete<CoursesController>();
          }
          break;
      }

      print("Disposed controller of index $oldIndex safely ✅");
    }

    selectedIndex.value = index;
  }

  late final LocationAccesss locationAccesss;

  // @override
  // void onInit() {
  //   super.onInit();
  //   locationAccesss = Get.put(LocationAccesss());
  //   checkLocationAccess();
  // }

  // @override
  // void onReady() {
  //   super.onReady();

  //   debugPrint('✅ DashboardController is ready!');
  // }

  @override
  void onInit() {
    super.onInit();
    locationAccesss = Get.put(LocationAccesss());
    checkLocationAccess();
  }

  // ✅ OLD onReady (commented out)
  // @override
  // void onReady() {
  //   super.onReady();
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     Get.find<LinkController>().retryPendingDeepLink();
  //   });
  // }

  // ✅ NEW onReady (Deep Link Fix - waits for widget tree to be painted)
  @override
  void onReady() {
    super.onReady();

    // Wait for the Dashboard widget tree to be fully painted on screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Extra safety delay after first frame is painted
      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.isRegistered<LinkController>()) {
          print('🔗 Dashboard ready, retrying pending deep link...');
          Get.find<LinkController>().retryPendingDeepLink();
        }
      });
    });
  }

  Future<void> checkLocationAccess() async {
    try {
      await locationAccesss.locationaccess();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
