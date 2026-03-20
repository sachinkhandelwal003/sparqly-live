import 'package:get/get.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../services/api_services/apiServices.dart';

class SubscriptionCheckController extends GetxController {
  Rx<SubscriptionPlanActive?> subscription = Rx<SubscriptionPlanActive?>(null);
  RxBool isLoading = false.obs;

  Future<void> loadSubscription() async {
    try {
      isLoading.value = true;

      final data = await ApiServices().fetchSubscriptionPlan();
      subscription.value = data;

      print("🎉 Subscription Loaded → ${data?.planName}");
    } catch (e) {
      print("⚠ Subscription Load Error → $e");
      subscription.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // 🔥 ALL FEATURES (18 keys exactly matching your API)
  // ---------------------------------------------------------------------------

  bool get chatAccess => subscription.value?.access.chatAccess ?? false;
  bool get analyticsAccess =>
      subscription.value?.access.analyticsAccess ?? false;
  bool get prioritySearch => subscription.value?.access.prioritySearch ?? false;
  bool get verifiedBadge => subscription.value?.access.verifiedBadge ?? false;
  bool get prioritySupport =>
      subscription.value?.access.prioritySupport ?? false;

  bool get businessAdd => subscription.value?.access.businessAdd ?? false;
  bool get jobAdd => subscription.value?.access.jobAdd ?? false;
  bool get influencerAdd => subscription.value?.access.influencerAdd ?? false;
  bool get courseAdd => subscription.value?.access.courseAdd ?? false;
  bool get offerAdd => subscription.value?.access.offerAdd ?? false;

  int get activeListing => subscription.value?.access.activeListing ?? 0;

  // Optional utility
  bool get isPremium => subscription.value?.planName == "Premium";
}
