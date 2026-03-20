import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  SubscriptionView({super.key});

  final SubscriptionController controller = Get.put(SubscriptionController());
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(
        title: "Subscription",
        onBackPressed: () {
          dashboardController.goToPage(0);
        },
      ),
      BodyWidget: Obx(() {
        final isYearly = controller.selectedPlanType.value == "Yearly";

        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            // Toggle Row for Monthly / Yearly
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Monthly",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isYearly ? Colors.black87 : Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: isYearly,
                  onChanged: (value) {
                    controller.selectPlanType(value ? "Yearly" : "Monthly");
                  },
                  activeColor: Colors.blue,
                ),
                const SizedBox(width: 12),
                Text(
                  "Yearly ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isYearly ? Colors.blue : Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "(Save up to 15%)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subscription Cards
            ...controller.plans.map((plan) {
              final isSelected = controller.selectedPlan.value == plan.id;
              final price = isYearly ? plan.yearlyPrice : plan.monthlyPrice;
              final features = _extractFeatures(plan.description);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _subscriptionCard(
                  planId: plan.id, // ✅ pass ID
                  planName: plan.name,
                  price: price,
                  periodText: isYearly ? "year" : "month",
                  shortDesc: plan.shortDesc,
                  features: features,
                  isSelected: isSelected,
                  isPopular: plan.isPopular == 1,
                  onTap: () {
                 //   controller.selectPlan(plan.id); // ✅ select by ID
                  },
                  onChoosePlan: () {
                    controller.createAndOpenSubscription(plan);
                  },

                ),
              );
            }).toList(),
          ],
        );
      }),
    );
  }

  /// Remove HTML tags
  String stripHtml(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  /// Extract features from HTML description
  List<String> _extractFeatures(String htmlString) {
    final regex = RegExp(r'<p>(.*?)<\/p>', multiLine: true, caseSensitive: false);
    final matches = regex.allMatches(htmlString);
    return matches
        .map((m) => stripHtml(m.group(1) ?? ''))
        .where((f) => f.isNotEmpty)
        .toList();
  }

  /// Subscription card widget
  Widget _subscriptionCard({
    required int planId,
    required String planName,
    required int price,
    required String periodText,
    required String shortDesc,
    required List<String> features,
    required bool isSelected,
    required bool isPopular,
    required VoidCallback onTap,
    required VoidCallback onChoosePlan,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isPopular
                  ? const BorderSide(color: Colors.orange, width: 2)
                  : isSelected
                  ? const BorderSide(color: Colors.blue, width: 2)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹$price / $periodText",
                    style: Theme.of(Get.context!)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                      color: Colors.grey.shade900,
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shortDesc,
                    style: Theme.of(Get.context!)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                      color: Colors.grey.shade800,
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features
                        .map(
                          (f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                f,
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                  color: Colors.grey.shade700,
                                  fontFamily: "Times New Roman",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: onChoosePlan,
                    child: AppCustomContainer(
                      height: MediaQuery.of(Get.context!).size.height * 0.05,
                      width: double.infinity,
                      borderradius: 10,
                      color: Colors.blue,
                      child: Center(
                        child: controller.isRazorpayLoading.value
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          "Choose Plan",
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                            color: Colors.white,
                            fontFamily: "Times New Roman",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: const Text(
                  "Most Popular",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
