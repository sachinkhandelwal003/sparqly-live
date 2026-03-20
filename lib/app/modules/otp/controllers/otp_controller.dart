import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sparqly/app/services/api_services/apiServices.dart';
import '../../../routes/app_pages.dart';

class OtpController extends GetxController {
  final RxBool isOtpSent = false.obs; // phone -> otp screen
  final RxInt secondsRemaining = 30.obs;
  final RxBool isLoading = false.obs;

  final phoneController = TextEditingController();
  Timer? _timer;

  // OTP input controllers
  final List<TextEditingController> otpControllers =
  List.generate(4, (_) => TextEditingController());

  String? savedMobile;

  final ApiServices _otpService = ApiServices();

  void startTimer() {
    secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  /// 📩 Send OTP
  Future<void> sendOtp(BuildContext context) async {
    if (phoneController.text.isEmpty) {
      Get.snackbar("Error", "Please enter phone number");
      return;
    }

    try {
      isLoading.value = true;
      http.Response response =
      await _otpService.sendOtp(phoneController.text);

      if (response.statusCode == 200) {
        print("✅ Otp ${response.body}");
        savedMobile = phoneController.text;
        isOtpSent.value = true;
        Get.snackbar("Success", "OTP sent successfully");
        startTimer();
      } else {
        Get.snackbar("Error", "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Resend OTP
  Future<void> resendOtp(BuildContext context) async {
    if (savedMobile == null) return;

    try {
      isLoading.value = true;
      http.Response response = await _otpService.sendOtp(savedMobile!);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "A new OTP has been sent.");
        startTimer();
      } else {
        Get.snackbar("Error", "Failed to resend OTP: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Verify OTP
  Future<void> verify4DigitOtp(BuildContext context) async {
    final storage = GetStorage();
    String otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.length != 4) {
      Get.snackbar("Warning", "Enter the complete 4-digit OTP");
      return;
    }

    try {
      isLoading.value = true;
      http.Response response = await _otpService.verifyOtp(savedMobile!, otp);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // ✅ Extract token safely
        final token = jsonData['data']?['token'] ?? '';
        final tokenType = jsonData['data']?['token_type'] ?? 'Bearer';

        // ✅ Extract user ID
        final userId = jsonData['data']?['user']?['id']; // <-- ADD THIS



        if (token.isNotEmpty) {
          // ✅ Save full Authorization header in GetStorage
          await storage.write('auth_token', '$tokenType $token');

          // 🚨 IMPORTANT: remove guest flag
          await storage.remove('is_guest');
          print("📌 Is_Guest : ${storage.read('is_guest')}");

          // ✅ Save user ID in storage
          if (userId != null) {
            await storage.write('user_id', userId);
            print("📌 User ID saved: $userId");
          }
          print("📌 Token saved in GetStorage: ${storage.read('auth_token')}");
        } else {
          print("❌ Token not found in response!");
        }

        // ✅ Close keyboard before navigating
        FocusScope.of(context).unfocus();
        Get.snackbar("Success", "OTP Verified");

        // ✅ Send user to Dashboard
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar("Error", "Incorrect OTP: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }



  @override
  void onClose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
