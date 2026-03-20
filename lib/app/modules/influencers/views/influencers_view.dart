import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../models/Get_Models_All/influencer_Get_Models.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../splash/controllers/subscriptionCheckController.dart';
import '../controllers/influencers_controller.dart';

class InfluencersView extends GetView<InfluencersController> {
  InfluencersView({super.key});

  final InfluencersController controller = Get.put(InfluencersController());
  final DashboardController dashboardController = Get.find<
      DashboardController>();

  // ⭐ ADDED FOR LOCK FEATURE
  final SubscriptionCheckController subscriptionController =
  Get.find<SubscriptionCheckController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    String truncateWords(String text, int wordLimit) {
      if (text.isEmpty) return "";
      List<String> words = text.split(' ');
      if (words.length <= wordLimit) return text;
      return words.sublist(0, wordLimit).join(' ') + '...';
    }


    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          final avatarRadius = constraints.maxWidth * 0.1;
          final paddingSize = constraints.maxWidth * 0.025;
          final fontSizeName = constraints.maxWidth * 0.045;
          final fontSizeNiche = constraints.maxWidth * 0.033;
          final fontSizeLocation = constraints.maxWidth * 0.030;
          final fontSizeStats = constraints.maxWidth * 0.025;

          return RefreshIndicator(
            color: AppColors.buttonColor,
            onRefresh: controller.fetchInfluencers,
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.015),

                // Search + Category Dropdown
                Obx(() {
                  final categories = <String>["All"];

                  categories.addAll(
                    controller.influencerList
                        .map((e) => e.niche.trim())
                        .where((niche) => niche.isNotEmpty)
                        .toSet() // ✅ removes duplicates
                        .toList(),
                  );

                  print("🔥 Categories from API: $categories");

                  return SearchAndFilterBar(
                    controller: controller.prioritySearchController,
                    categories: categories,
                    searchHint: "Search influencers...",
                    categoryLabel: "Category",
                  );
                }),


                // Influencer List
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
                            Icon(Icons.wifi_off,
                                size: 50, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey.shade700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => controller.fetchInfluencers(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
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
                        .map((e) => InfluencerData.fromJson(e))
                        .toList()
                        : controller.influencerList;

                    final items = controller.applyCategoryAndRadiusFilter(rawList);


                    if (items.isEmpty) {
                      return Center(
                        child: AppCustomTexts(
                          TextName: "No influencers found",
                          textStyle: textTheme.displayMedium,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(paddingSize),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {

                              controller.selectedId.value = item.id;
                              dashboardController.goToPage(19);

                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: paddingSize),
                            child: Stack(
                              children: [
                                AppCustomContainer(
                                  color: AppColors.white,
                                  width: double.infinity,
                                  borderradius: 16,
                                  widthColor: Colors.grey.shade300,
                                  widthsize: 1,
                                  padding: EdgeInsets.all(paddingSize),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      // Avatar
                                      CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage:
                                        NetworkImage(item.image ?? ""),
                                        onBackgroundImageError:
                                            (error, stackTrace) =>
                                        const Icon(Icons.person,
                                            size: 40),
                                      ),
                                      SizedBox(width: paddingSize),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            // Name
                                            AppCustomTexts(
                                              TextName: item.name ?? "",
                                              textStyle: textTheme.displayLarge!
                                                  .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: fontSizeName,
                                                color: Colors.black87,
                                              ),
                                              maxLine: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),

                                            // Niche
                                            AppCustomTexts(
                                              TextName:
                                              item.niche ?? "Content Creator",
                                              textStyle: textTheme.bodyLarge!
                                                  .copyWith(
                                                fontSize: fontSizeNiche,
                                                color: Colors.blueGrey.shade700,
                                                fontFamily: "Times New Roman",
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLine: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 6),

                                            //Location
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on,
                                                    size: 18,
                                                    color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: AppCustomTexts(
                                                    TextName: item.location ??
                                                        "Creator location",
                                                    textStyle: textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      fontSize: fontSizeLocation,
                                                      color: Colors.grey.shade800,
                                                      fontFamily:
                                                      "Times New Roman",
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    maxLine: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),

                                            // Social stats
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                _buildSocialStat(
                                                  icon:
                                                  FontAwesomeIcons.instagram,
                                                  label:
                                                  item.instagram ?? "0",
                                                  fontSize: fontSizeStats,
                                                  color: Colors.pinkAccent,
                                                ),
                                                _buildSocialStat(
                                                  icon: FontAwesomeIcons.youtube,
                                                  label: item.youtube ?? "0",
                                                  fontSize: fontSizeStats,
                                                  color: Colors.redAccent,
                                                ),
                                                _buildSocialStat(
                                                  icon: FontAwesomeIcons.linkedin,
                                                  label: item.linkedin ?? "0",
                                                  fontSize: fontSizeStats,
                                                  color: Colors.blue,
                                                ),
                                                _buildSocialStat(
                                                  icon: FontAwesomeIcons.facebook,
                                                  label: item.facebook ?? "0",
                                                  fontSize: fontSizeStats,
                                                  color: Colors.indigo,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Category Badge (top-right)
                                Positioned(
                                  right: paddingSize,
                                  top: paddingSize,
                                  child: IntrinsicWidth(
                                    child: AppCustomContainer(
                                      borderradius: 4,
                                      color: AppColors.dividercolor.withOpacity(0.25),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.category, size: 12, color: Colors.blueGrey),
                                            const SizedBox(width: 3),
                                            AppCustomTexts(
                                              TextName: truncateWords(item.profession ?? "General", 2),
                                              textStyle: textTheme.bodySmall!.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.blueGrey.shade900,
                                                fontFamily: "Times New Roman",
                                              ),
                                              maxLine: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
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

  /// 🔹 Helper Widget for Social Stats
  Widget _buildSocialStat({
    required IconData icon,
    required String label,
    required double fontSize,
    Color? color,
  }) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 5, color: color ?? Colors.grey.shade700),
          const SizedBox(width: 4), // fixed spacing for consistency
          Expanded(
            child: AppCustomTexts(
              TextName: label,
              textStyle: Theme
                  .of(Get.context!)
                  .textTheme
                  .bodyMedium!
                  .copyWith(
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
              maxLine: 1, // prevent overflow
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}
