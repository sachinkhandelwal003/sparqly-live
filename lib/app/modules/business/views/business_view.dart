import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';
import '../../../widgets/Custom_Widgets/App_RichText.dart';
import '../../splash/controllers/subscriptionCheckController.dart';
import '../controllers/business_controller.dart';
import '../../../models/Get_Models_All/business_Get_Model.dart';

class BusinessView extends GetView<BusinessController> {
  BusinessView({super.key});
  // final BusinessController controller = Get.put(BusinessController());
  final BusinessController controller = Get.find<BusinessController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final SubscriptionCheckController subscriptionController =
      Get.find<SubscriptionCheckController>();

  @override
  Widget build(BuildContext context) {
    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          final textTheme = Theme.of(context).textTheme;
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;

          return RefreshIndicator(
            color: AppColors.buttonColor,
            onRefresh: controller.fetchBusinesses,
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.01),
                SearchAndFilterBar(
                  controller: controller.prioritySearchController,
                  categories: controller.categories,
                  searchHint: "Search businesses...",
                  categoryLabel: "Category",
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => controller.fetchBusinesses(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    final rawList =
                        controller.prioritySearchController.results.isNotEmpty
                        ? controller.prioritySearchController.results
                              .whereType<Map<String, dynamic>>() //  SAFETY
                              .map((e) => BusinessData.fromJson(e))
                              .toList()
                        : controller.businessList;

                    final items = controller.applyCategoryAndRadiusFilter(
                      rawList,
                    );

                    if (items.isEmpty) {
                      return Center(
                        child: AppCustomTexts(
                          TextName: "No businesses found",
                          textStyle: textTheme.displayMedium!.copyWith(
                            color: AppColors.dividercolor,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildBusinessCard(
                          item,
                          constraints,
                          textTheme,
                          screenWidth,
                          screenHeight,
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

  // Business Card
  Widget _buildBusinessCard(
    BusinessData item,
    BoxConstraints constraints,
    TextTheme textTheme,
    screenWidth,
    screenHeight,
  ) {
    return GestureDetector(
      onTap: () {
        controller.selectedId.value = item.id;
        dashboardController.goToPage(17);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AppCustomContainer(
          color: Colors.white,
          borderradius: 12,
          widthColor: Colors.grey.shade300,
          widthsize: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusinessImage(item, constraints),
              _buildBusinessDetails(item, constraints, textTheme),
            ],
          ),
        ),
      ),
    );
  }
}

// Business Image with Category Badge
Widget _buildBusinessImage(BusinessData item, BoxConstraints constraints) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(Get.context!).size.height * 0.25,
          color: Colors.grey[50],
          child: Image.network(
            item.image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),

        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.category, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  item.businessCategory ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBusinessDetails(
  BusinessData item,
  BoxConstraints constraints,
  TextTheme textTheme,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: constraints.maxHeight * 0.01),
        AppCustomTexts(
          TextName: item.name,
          textStyle: textTheme.displayLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.01),
        AppCustomTexts(
          TextName: item.description.isNotEmpty
              ? item.description
              : "No description available",
          textStyle: textTheme.bodyLarge!.copyWith(
            fontFamily: "Times New Roman",
          ),
          maxLine: 2,
        ),
        SizedBox(height: constraints.maxHeight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppRichtext(
              textspan:
                  "  ${item.location.isNotEmpty ? item.location : "Unknown Location"}",
              anywidget: const Icon(Icons.pin_drop_outlined, size: 13),
              textStyle: textTheme.bodySmall!.copyWith(
                fontFamily: "Times New Roman",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppCustomTexts(
                TextName: "View Detail",
                textStyle: textTheme.bodySmall!.copyWith(
                  fontFamily: "Times New Roman",
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPremiumOverlay(double screenWidth, double screenHeight) {
  return Positioned.fill(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.45),
                Colors.black.withOpacity(0.25),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade300,
                          Colors.deepOrange.shade600,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.shade200.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(
                      Icons.lock,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Premium Course",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'RobotoSlab',
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Unlock exclusive premium content",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Subscribe Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
