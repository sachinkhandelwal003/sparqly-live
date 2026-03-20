// import 'package:get/get.dart';
// import 'package:sparqly/app/modules/courseDetailUi/controllers/course_detail_ui_controller.dart';
// import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
// import 'package:sparqly/app/modules/home/controllers/home_controller.dart';
//
// class AppRefreshManager {
//   static final dashboard = Get.find<DashboardController>();
//   static final home = Get.find<HomeController>();
//   static final listing = Get.find<CourseDetailUiController>();
//   static final bookmark = Get.find<BookmarkController>();
//
//   /// 🔵 Refresh data after subscription purchase
//   static Future<void> refreshAfterSubscription() async {
//     try {
//       // USER INFO (subscription flags, premium access, etc.)
//       await dashboard.loadUserProfile();
//
//       // HOME RELATED
//       await home.fetchHeroSections();
//       await home.fetchExploreData();
//       await home.fetchNearbyOffers();
//       await home.fetchTrendingData();
//
//       // BOOKMARKS (in case premium unlocks something)
//       await bookmark.fetchBookmarks();
//
//       // LISTINGS (sometimes premium affects visibility)
//       await listing.getItem();
//
//       dashboard.update();
//       home.update();
//       bookmark.update();
//       listing.update();
//     } catch (e) {
//       print("Refresh Error ===> $e");
//     }
//   }
//
//   /// 🔵 Refresh when App Opens (Splash/Home)
//   static Future<void> refreshOnAppStart() async {
//     await home.fetchHeroSections();
//     await home.fetchExploreData();
//     await home.fetchNearbyOffers();
//     await home.fetchTrendingData();
//     await dashboard.loadUserProfile();
//   }
//
//   /// 🔵 Refresh when Opening Listing Page
//   static Future<void> refreshListing() async {
//     await listing.getItem();
//   }
//
//   /// 🔵 Refresh when opening Bookmark Page
//   static Future<void> refreshBookmarks() async {
//     await bookmark.fetchBookmarks();
//   }
//
//   /// 🔵 Refresh Detail Page
//   static Future<void> refreshDetail({required int id}) async {
//     await listing.getDetailItem(id);
//     await listing.fetchReviewData(id);
//   }
// }
