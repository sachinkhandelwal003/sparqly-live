import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/App_Assets.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: controller.scaleAnimation,
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: Image.asset(
              AppAssets.appLogo,
              height: screenHeight * 0.15,
              width: screenWidth * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}