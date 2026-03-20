// import 'package:flutter/animation.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:sparqly/app/modules/splash/controllers/subscriptionCheckController.dart';
// import 'package:sparqly/app/routes/app_pages.dart';

// class SplashController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<double> scaleAnimation;
//   late Animation<double> fadeAnimation;

//   final storage = GetStorage();
//   // ADD: Global Subscription Controller
//   final subscriptionController = Get.find<SubscriptionCheckController>();

//   @override
//   void onInit() {
//     super.onInit();

//     // Future.delayed(const Duration(milliseconds: 500), () {
//     //   DeepLinkService.init();
//     // });

//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3), //  whole splash timeline
//     );

//     fadeAnimation = CurvedAnimation(
//       parent: animationController,
//       curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
//     );

//     scaleAnimation = CurvedAnimation(
//       parent: animationController,
//       curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
//     );
//     // 🚀 LOAD SUBSCRIPTION IMMEDIATELY
//     subscriptionController.loadSubscription();

//     animationController.forward();

//     animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _checkAuthToken();
//       }
//     });
//   }

//   void _checkAuthToken() {
//     final token = storage.read('auth_token');
//     if (token != null && token.toString().isNotEmpty) {
//       print("📌 Auth token found in storage: $token");
//       // ✅ If token exists → go to Home/Dashboard
//       Get.offAllNamed(Routes.DASHBOARD);
//     } else {
//       print("❌ No token found in storage, redirecting to OTP/Login");
//       // ❌ No token → go to OTP/Login
//       Get.offAllNamed(Routes.OTP);
//     }
//   }

//   @override
//   void onClose() {
//     animationController.dispose();
//     super.onClose();
//   }
// }

// lib/app/modules/splash/controllers/splash_controller.dart

// lib/app/modules/splash/controllers/splash_controller.dart

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparqly/app/link_controller.dart';
import 'package:sparqly/app/routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  final storage = GetStorage();
  late final LinkController _linkController;

  @override
  void onInit() {
    super.onInit();

    _linkController = Get.find<LinkController>();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
    );

    scaleAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    );

    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  // ✅ OLD _navigateToNextScreen (commented out)
  // void _navigateToNextScreen() {
  //   final token = storage.read('auth_token');
  //   final hasToken = token != null && token.toString().isNotEmpty;
  //   if (hasToken) {
  //     Get.offAllNamed(Routes.DASHBOARD);
  //   } else {
  //     Get.offAllNamed(Routes.OTP);
  //   }
  // }

  // ✅ NEW _navigateToNextScreen (Deep Link Fix)
  void _navigateToNextScreen() {
    final token = storage.read('auth_token');
    final hasToken = token != null && token.toString().isNotEmpty;

    if (hasToken) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      // Clear pending deep link if user is not logged in
      _linkController.clearPendingDeepLink();
      Get.offAllNamed(Routes.OTP);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
