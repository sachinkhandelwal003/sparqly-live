import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import '../../../models/Get_Models_All/subscription_model.dart';

class SubscriptionController extends GetxController {
  final api = ApiServices();

  // Observables
  var plans = <SubscriptionPlan>[].obs;
  var selectedPlanType = 'Monthly'.obs;
  var selectedPlan = 0.obs; // ✅ store plan ID
  var isLoading = false.obs;
  var razorpayKey = ''.obs;
  var subscriptionId = ''.obs;
  var isRazorpayLoading = false.obs;


  late Razorpay _razorpay;

  @override
  void onInit() {
    super.onInit();

    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    loadPlans();
    loadRazorpayKeys();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  // Load subscription plans from API
  Future<void> loadPlans() async {
    isLoading(true);
    final response = await api.fetchPlans();
    if (response != null && response.data.isNotEmpty) {
      plans.assignAll(response.data);
      selectedPlan.value = plans[0].id; // ✅ select first plan by ID
    }
    isLoading(false);
  }

  // Load Razorpay keys
  Future<void> loadRazorpayKeys() async {
    final keys = await api.fetchRazorpayKeys();
    if (keys != null) razorpayKey.value = keys["key"] ?? "";
  }

  // Select plan by ID
  void selectPlan(int planId) => selectedPlan.value = planId;

  void selectPlanType(String type) => selectedPlanType.value = type;

  /// 🔹 Create and open subscription
  Future<void> createAndOpenSubscription(SubscriptionPlan plan) async {
    final planIdForBackend = plan.id;
    final billingType = selectedPlanType.value.toLowerCase();

    final data = await api.createSubscription(
      planId: planIdForBackend,
      billingType: billingType,
    );

    if (data == null) {
      Get.snackbar("Error", "Failed to create subscription");
      return;
    }

    if (data["status"] == true) {
      // Subscription already purchased
      if (data["message"] == "You have already purchased a plan.") {
        Get.defaultDialog(
          title: "Subscription",
          middleText: data["message"],
          backgroundColor: AppColors.white,
          radius: 16,
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          barrierDismissible: true,
          textConfirm: "OK",
          buttonColor: AppColors.buttonColor,
          confirmTextColor: AppColors.white,
          onConfirm: () {
            Get.back();
          },
        );

        return; // Stop further processing
      }

      // Otherwise, create new subscription
      subscriptionId.value = data["data"]["subscription_id"];
      razorpayKey.value = data["data"]["razorpay_key"];

      final razorpayPlanId = billingType == "yearly"
          ? plan.razorpayYearlyPlanId
          : plan.razorpayMonthlyPlanId;

      if (razorpayPlanId == null) {
        Get.snackbar("Error", "Razorpay plan ID missing");
        return;
      }
      isRazorpayLoading(true);
      _openRazorpayCheckout(plan.name, razorpayPlanId);
    } else {
      // Other errors
      Get.snackbar("Error", data["message"] ?? "Failed to create subscription");
    }
  }



  void _openRazorpayCheckout(String planName, String razorpayPlanId) {
    _razorpay.open({
      'key': razorpayKey.value,
      'subscription_id': subscriptionId.value,
      'name': 'Sparqly Subscription',
      'description': planName,
      'plan_id': razorpayPlanId,
      'prefill': {'contact': '9999999999', 'email': 'user@example.com'},
      'theme': {'color': '#1F73F0'},
    });
  }

  // Payment success handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isRazorpayLoading(false);

    final result = await api.verifySubscription(
      paymentId: response.paymentId!,
      subscriptionId: subscriptionId.value,
      signature: response.signature!,
    );

    if (result != null && result["status"] == true) {
      print(
          "\x1B[32m✅ Payment Success Details:\n"
              "Payment ID: ${response.paymentId}\n"
              "Subscription ID: ${subscriptionId.value}\n"
              "Signature: ${response.signature}\x1B[0m"
      );
      Get.snackbar("Success", "Subscription activated");
    } else {
      Get.snackbar("Error", "Subscription verification failed");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isRazorpayLoading(false);
    Get.snackbar("Payment Failed", response.message ?? "Something went wrong");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    isRazorpayLoading(false);
    Get.snackbar("External Wallet", response.walletName ?? "");
  }

  /// 🔹 Cancel subscription
  Future<void> cancelCurrentSubscription() async {
    final result = await api.cancelSubscription(
      subscriptionId: subscriptionId.value,
    );

    if (result != null && result["status"] == true) {
      Get.snackbar("Success", "Subscription canceled");
    } else {
      Get.snackbar("Error", "Failed to cancel subscription");
    }
  }
}
