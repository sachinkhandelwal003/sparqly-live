import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Filters.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../models/Get_Models_All/offer_Get_Models.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../splash/controllers/subscriptionCheckController.dart';
import '../controllers/offers_controller.dart';

class OffersView extends GetView<OffersController> {
  final controller = Get.put(OffersController());

  OffersView({super.key});

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
   // subscriptionController.loadSubscription();
    final textTheme = Theme.of(context).textTheme;

    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return RefreshIndicator(
            color: AppColors.buttonColor,
            onRefresh: () async {
              await controller.fetchOffers();
            },
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                // 🔎 Search & Filter
                Obx(() {
                  final categories = <String>["All"];
                  categories.addAll(
                    controller.offersList
                        .map((e) => e.discountType)
                        .toSet()
                        .toList(),
                  );

                  return SearchAndFilterBar(
                    controller: controller.prioritySearchController,
                    categories: [],
                    searchHint: "Search influencers...",
                    categoryLabel: "Category",
                  );
                }),

                // 📡 Offers List
                Expanded(
                  child: Obx(() {
                    // 🔄 Loading state
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ❌ Error state
                    if (controller.errorMessage.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade400,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            AppCustomTexts(
                              TextName: controller.errorMessage.value,
                              textStyle: textTheme.displayMedium?.copyWith(
                                color: Colors.red.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLine: 3,
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton.icon(
                              onPressed: controller.fetchOffers,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              label: const Text("Retry"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // 📭 Empty state
                    final rawList = controller.prioritySearchController.results.isNotEmpty
                        ? controller.prioritySearchController.results
                        .map((e) => OfferData.fromJson(e))
                        .toList()
                        : controller.offersList;


                    final offers = controller.applyCategoryAndRadiusFilter(rawList);
                    if (offers.isEmpty) {
                      return Center(
                        child: AppCustomTexts(
                          TextName: "No offers found",
                          textStyle: textTheme.displayMedium,
                        ),
                      );
                    }

                    // ✅ Data state with subscription check
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final OfferData offer = offers[index];


                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                    controller.selectedId.value = offer.id;
                                    dashboardController.goToPage(20);
                                },
                                child: AppCustomContainer(
                                  width: double.infinity,
                                  borderradius: 16,
                                  child: Card(
                                    color: AppColors.white,
                                    elevation: 2,
                                    shadowColor: Colors.grey.shade200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 🖼️ Offer Image
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: SizedBox(
                                                width: double.infinity,
                                                height:
                                                    MediaQuery.of(
                                                      Get.context!,
                                                    ).size.height *
                                                    0.25,
                                                child: Image.network(
                                                  offer.image ?? "",
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          color:
                                                              Colors.grey[200],
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .broken_image,
                                                              size: 40,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                  loadingBuilder:
                                                      (
                                                        context,
                                                        child,
                                                        loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null)
                                                          return child;
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        // 📄 Offer Info (unchanged)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 13.0,
                                            left: 25,
                                            bottom: 25,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              AppCustomTexts(
                                                TextName: offer.title ?? "",
                                                textStyle: textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 6),
                                              AppCustomTexts(
                                                TextName:
                                                    offer.description ?? "",
                                                textStyle: textTheme.bodyLarge!
                                                    .copyWith(
                                                      fontFamily:
                                                          "Times New Roman",
                                                    ),
                                                maxLine: 2,
                                              ),
                                              const SizedBox(height: 13),
                                              Row(
                                                children: [
                                                  AppCustomTexts(
                                                    TextName:
                                                        "₹${offer.discountValue ?? "0"}",
                                                    textStyle: textTheme
                                                        .headlineMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .blue
                                                              .shade700,
                                                          fontFamily:
                                                              "Times New Roman",
                                                        ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Text(
                                                    "₹${offer.originalPrice ?? "0"}",
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          "Times New Roman",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  AppCustomTexts(
                                                    TextName:
                                                        "Valid until ${offer.offerValidity}" ??
                                                        "",
                                                    textStyle: textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          fontFamily:
                                                              "Times New Roman",
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              AppCustomTexts(
                                                TextName: "View Offer",
                                                textStyle: textTheme.bodyLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          "Times New Roman",
                                                      color: Colors.blue,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
