import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:sparqly/app/constants/App_Assets.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';

class ReferalController extends GetxController {
  var referralCode = "ABC123XYZ".obs;
  final  TextEditingController referralCodeController = TextEditingController();
  final DashboardController dashboardController = Get.find();
  @override
  void onInit() {
    super.onInit();
    // referralCodeController = TextEditingController(text: referralCode.value);
    //
    // // Keep controller in sync with observable
    // ever(referralCode, (_) {
    //   referralCodeController.text = referralCode.value;
    // });
  }

  void copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showReferralPopup() {
    final context = Get.context;
    if (context == null) return;

    showDialog(
      context: context,
    //  barrierDismissible: false,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context).size;

        // Auto dismiss after 3.5 seconds
        Future.delayed(const Duration(milliseconds: 4500), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
           // height: mediaQuery.height * 0.50, // increased dialog height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top image (normal)
                Image.asset(
                  AppAssets.referralImg,
                  height: mediaQuery.height * 0.22, // larger image
                  width: double.infinity,
                  fit: BoxFit.contain, // preserve image proportion
                ),
                const SizedBox(height: 25),

                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '🎉 Claim Your Referral!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

// Subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'You have a new referral reward waiting! Tap "Claim Now" to add it to your account and keep inviting friends to earn more.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4, // improves readability
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Claim button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                      dashboardController.goToPage(24);
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Claim Now",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  var isLoading = false.obs;
  var message = ''.obs;
  var inviterPoints = 0.obs;
  var yourPoints = 0.obs;

  Future<void> applyReferral(String referralCode) async {
    try {
      isLoading.value = true;
      message.value = '';

      final response = await ApiServices().applyReferral(referralCode);

      if (response != null && response['status'] == true) {
        message.value = response['message'] ?? 'Referral applied successfully';
        final data = response['data'] ?? {};

        inviterPoints.value = data['inviter_points'] ?? 0;
        yourPoints.value = data['your_points'] ?? 0;

        print("✅ Referral Applied: Inviter=${inviterPoints.value}, You=${yourPoints.value}");
      } else {
        message.value = response?['message'] ?? 'Failed to apply referral';
        print("❌ API Error: ${message.value}");
      }
    } catch (e) {
      message.value = "⚠️ Unexpected error: $e";
      print("⚠️ Exception in Controller: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    referralCodeController.dispose();
    super.onClose();
  }
}
