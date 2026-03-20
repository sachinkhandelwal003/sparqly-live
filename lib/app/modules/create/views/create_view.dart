import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Const_Texts.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../constants/App_All_list.dart';
import '../../../constants/App_Colors.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../controllers/create_controller.dart';

class CreateView extends GetView<CreateController> {
  CreateView({super.key});
  final DashboardController dashboardController = Get.find<DashboardController>();

  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices().fetchSubscriptionPlan();
    },
  );
  void showUpgradePopup() {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              const Text(
                "Upgrade Required",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "You’ve reached your plan limit. Upgrade your subscription to add more listings.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        dashboardController.goToPage(23);
                      },
                      child: const Text("Upgrade"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }


  @override
  Widget build(BuildContext context) {

    subscriptionController.loadData();


    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.02),
                AppCustomTexts(
                  paddingHorizontal: mediaQuery.size.width * 0.04,
                  TextName: AppConstTexts.categoryTitle,
                  Textalign: TextAlign.center,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500,fontFamily: "Times New Roman"),
                ),

                SizedBox(height: mediaQuery.size.height * 0.01),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: AppAllList.createNewListing.length,
                  itemBuilder: (context, index) {
                    final item = AppAllList.createNewListing[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 1),
                      child: GestureDetector(
                        onTap: () {
                          final sub = subscriptionController.data.value;

                          // ⏳ Still loading or API not returned yet
                          if (subscriptionController.isLoading.value || sub == null) {
                            Get.snackbar(
                              "Please wait",
                              "Checking your subscription...",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }


                          if (index == 0) {
                            dashboardController.goToPage(5);  // BusinessListingsView
                          } else if (index == 1) {
                            dashboardController.goToPage(6);  // JobsListingsView
                          } else if (index == 2) {
                            dashboardController.goToPage(7);  // InfluencersListingsView
                          }  // COURSE
                          if (index == 3) {
                            if (!sub.access.courseAdd) {
                              showUpgradePopup();

                              return; // ⛔ STOP NAVIGATION
                            }
                            dashboardController.goToPage(8); // CourseListingsView
                          }

                          // OFFER
                          else if (index == 4) {
                            if (!sub.access.offerAdd) {
                              showUpgradePopup();

                              return; // ⛔ STOP NAVIGATION
                            }
                            dashboardController.goToPage(9); // OffersListingsView
                          } else if (index == 5) {
                            dashboardController.goToPage(10); // AdListingsView
                          }
                        },
                        child: SizedBox(
                          height: mediaQuery.size.height * 0.115,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    item["icon"],
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppCustomTexts(
                                          TextName: item["title"],
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.displayMedium!.copyWith(color: AppColors.black,fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        AppCustomTexts(
                                          TextName: item["subtitle"],
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!.copyWith(color: AppColors.black,fontFamily: "Times New Roman"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
