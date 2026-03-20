import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sparqly/app/modules/business/controllers/business_controller.dart';
import 'package:sparqly/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:sparqly/app/modules/influencers/controllers/influencers_controller.dart';
import 'package:sparqly/app/modules/offers/controllers/offers_controller.dart';
import 'package:sparqly/app/modules/courses/controllers/courses_controller.dart';
import 'package:sparqly/app/routes/app_pages.dart';

// class LinkController extends GetxController {
//   final _appLinks = AppLinks();
//   StreamSubscription? _linkSubscription;

//   @override
//   void onInit() {
//     super.onInit();
//     initDeepLinks();
//   }

//   @override
//   void onClose() {
//     _linkSubscription?.cancel();
//     super.onClose();
//   }

//   void initDeepLinks() async {
//     // 1. Cold Start (Jab app completely close/kill ho)
//     final initialLink = await _appLinks.getInitialLink();
//     if (initialLink != null) {
//       // ✋ Thoda wait taaki Splash render hone ka time mile
//       await Future.delayed(const Duration(milliseconds: 1500));
//       _handleNavigation(initialLink);
//     }

//     // 2. Background/Resume
//     _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
//       _handleNavigation(uri);
//     });
//   }

//   void _handleNavigation(Uri uri) async {
//     final segments = uri.pathSegments;
//     if (segments.length < 2) return;

//     String type = segments[0].toLowerCase();
//     int? id = int.tryParse(segments[1]);
//     if (id == null) return;

//     // --- COLD START PROTECTION ---
//     // Jab tak Dashboard ready nahi hota, tab tak loop chalega (Max 15 seconds)
//     int attempts = 0;
//     while (attempts < 30) {
//       // Logic: DashboardController register ho gaya ho aur Route 'Splash' na ho
//       if (Get.isRegistered<DashboardController>() &&
//           Get.currentRoute == Routes.DASHBOARD) {
//         break;
//       }
//       await Future.delayed(const Duration(milliseconds: 500));
//       attempts++;
//     }

//     // Final checks before navigating
//     if (Get.isRegistered<DashboardController>()) {
//       // 300ms ka buffer delay stable rendering ke liye
//       await Future.delayed(const Duration(milliseconds: 300));
//       _navigateToPage(type, id);
//     }
//   }

//   void _navigateToPage(String type, int id) {
//     final dashboardController = Get.find<DashboardController>();

//     switch (type) {
//       case 'business':
//         Get.put(BusinessController()).selectedId.value = id;
//         dashboardController.goToPage(17);
//         break;
//       case 'job':
//         Get.put(JobsController()).selectedId.value = id;
//         dashboardController.goToPage(18);
//         break;
//       case 'influencer':
//         Get.put(InfluencersController()).selectedId.value = id;
//         dashboardController.goToPage(19);
//         break;
//       case 'offer':
//         Get.put(OffersController()).selectedId.value = id;
//         dashboardController.goToPage(20);
//         break;
//       case 'course':
//         Get.put(CoursesController()).selectedId.value = id;
//         dashboardController.goToPage(21);
//         break;
//     }
//   }
// }

// lib/app/modules/link/controllers/link_controller.dart

// lib/app/modules/link/controllers/link_controller.dart

class LinkController extends GetxController {
  static LinkController get to => Get.find();

  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  Uri? _pendingDeepLink;
  bool get hasPendingDeepLink => _pendingDeepLink != null;

  @override
  void onInit() {
    super.onInit();
    print('📱 LinkController initialized');
    _initDeepLinks();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initDeepLinks() async {
    try {
      // ✅ Cold Start
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        print('📩 Cold start deep link: $initialLink');
        _pendingDeepLink = initialLink;
      }

      // ✅ Background/Resume (also handles cold start on some devices)
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          print('📩 Deep link received: $uri');
          // If Dashboard not ready (cold start), store as pending
          if (!Get.isRegistered<DashboardController>()) {
            print('⏳ Dashboard not ready, storing link from stream');
            _pendingDeepLink = uri;
            return;
          }
          _handleNavigation(uri);
        },
        onError: (error) {
          print('❌ Deep link error: $error');
        },
      );

      print('🎯 Deep link listener active');
    } catch (e) {
      print('❌ Error initializing deep links: $e');
    }
  }

  Future<void> _handleNavigation(Uri uri) async {
    final segments = uri.pathSegments;
    if (segments.length < 2) return;

    String type = segments[0].toLowerCase();
    int? id = int.tryParse(segments[1]);
    if (id == null) return;

    // If Dashboard not ready, store it
    if (!Get.isRegistered<DashboardController>()) {
      print('⏳ Dashboard not ready, storing link');
      _pendingDeepLink = uri;
      return;
    }

    _navigateToPage(type, id);
  }

  void _navigateToPage(String type, int id) {
    final dashboardController = Get.find<DashboardController>();

    switch (type) {
      case 'business':
        Get.put(BusinessController(), permanent: true);
        Get.find<BusinessController>().selectedId.value = id;
        dashboardController.goToPage(17);
        break;

      case 'job':
        Get.put(JobsController(), permanent: true);
        Get.find<JobsController>().selectedId.value = id;
        dashboardController.goToPage(18);
        break;

      case 'influencer':
        Get.put(InfluencersController(), permanent: true);
        Get.find<InfluencersController>().selectedId.value = id;
        dashboardController.goToPage(19);
        break;

      case 'offer':
        Get.put(OffersController(), permanent: true);
        Get.find<OffersController>().selectedId.value = id;
        dashboardController.goToPage(20);
        break;

      case 'course':
        Get.put(CoursesController(), permanent: true);
        Get.find<CoursesController>().selectedId.value = id;
        dashboardController.goToPage(21);
        break;
    }

    print('✅ Navigated to $type with ID: $id');
  }

  // ✅ OLD retryPendingDeepLink (commented out)
  // void retryPendingDeepLink() {
  //   if (_pendingDeepLink != null) {
  //     print('🔄 Retrying pending deep link');
  //     final uri = _pendingDeepLink!;
  //     _pendingDeepLink = null;
  //     _handleNavigation(uri);
  //   }
  // }

  // ✅ NEW: Clear pending deep link (for non-logged-in users)
  void clearPendingDeepLink() {
    _pendingDeepLink = null;
  }

  // ✅ NEW retryPendingDeepLink (Deep Link Fix - with Dashboard safety check)
  void retryPendingDeepLink() {
    if (_pendingDeepLink != null) {
      print('🔄 Retrying pending deep link');
      final uri = _pendingDeepLink!;
      _pendingDeepLink = null;

      // Safety check: Dashboard must be registered
      if (!Get.isRegistered<DashboardController>()) {
        print('⚠️ Dashboard not registered, cannot process deep link');
        _pendingDeepLink = uri; // Store it back for later
        return;
      }

      _handleNavigation(uri);
    }
  }
}
