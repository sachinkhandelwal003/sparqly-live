
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../models/Get_Models_All/job_Get_Models.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/jobs_controller.dart';


class JobsView extends GetView<JobsController> {
  JobsView({super.key});
  final JobsController controller = Get.put(JobsController());
  final DashboardController dashboardController = Get.find<DashboardController>();


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          final paddingSize = constraints.maxWidth * 0.03;
          final imageHeight = constraints.maxHeight * 0.08;
          final imageWidth = constraints.maxWidth * 0.2;

          return RefreshIndicator(
            color: AppColors.buttonColor,
            onRefresh: controller.fetchJobs,
            child: Column(
              children: [
                SizedBox(height: mediaQuery.size.height * 0.01),

                // Search + Category Dropdown
                Obx(() {
                  final categories = <String>["All"];
                  categories.addAll(
                    controller.jobsList
                        .map((e) => e.jobType ?? "Other")
                        .toSet()
                        .toList(),
                  );

                  return SearchAndFilterBar(
                    controller: controller.prioritySearchController,
                    categories: categories,
                    searchHint: "Search jobs...",
                    categoryLabel: "Category",
                  );

                }),

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
                              onPressed: () => controller.fetchJobs(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
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
                        .map((e) => JobData.fromJson(e))
                        .toList()
                        : controller.jobsList;

                    final items = controller.applyCategoryAndRadiusFilter(rawList);


                    if (items.isEmpty) {
                      return Center(
                        child: AppCustomTexts(
                          TextName: "No jobs found",
                          textStyle: textTheme.displayMedium,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.all(paddingSize),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return buildJobCard(
                          item: item,
                          constraints: constraints,
                          textTheme: textTheme,
                          context: context,
                          imageHeight: imageHeight,
                          imageWidth: imageWidth,
                          paddingSize: paddingSize,
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

  // Job Card Widget WITH LOCK FEATURE ADDED
  Widget buildJobCard({
    required dynamic item,
    required BoxConstraints constraints,
    required TextTheme textTheme,
    required BuildContext context,
    required double imageHeight,
    required double imageWidth,
    required double paddingSize,
  }) {

    return Padding(
      padding: EdgeInsets.only(bottom: paddingSize),
      child: GestureDetector(
        onTap: () {

            controller.selectedId.value = item.id ?? 0;
            dashboardController.goToPage(18);

        },
        child: Column(
          children: [
            AppCustomContainer(
              color: Colors.white,
              borderradius: 12,
              widthColor: Colors.grey.shade300,
              widthsize: 1,
              padding: EdgeInsets.all(paddingSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE + TITLE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.image ?? "",
                          height: imageHeight,
                          width: imageWidth,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: imageHeight,
                                width: imageWidth,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, size: 30),
                              ),
                        ),
                      ),

                      SizedBox(width: paddingSize),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppCustomTexts(
                              TextName: item.title ?? "Untitled Job",
                              textStyle: textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: paddingSize * 0.2),
                            AppCustomTexts(
                              maxLine: 1,
                              TextName: "at ${item.companyName}",
                              textStyle: textTheme.bodyLarge!.copyWith(
                                color: Colors.grey.shade700,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Type badge
                      AppCustomButton(
                        color: AppColors.dividercolor.withOpacity(0.3),
                        borderradius: 10,
                        action: () {},
                        height: constraints.maxHeight * 0.03,
                        width: constraints.maxWidth * 0.2,
                        CustomName: AppCustomTexts(
                          TextName: item.jobType ?? "Contract",
                          textStyle: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Times New Roman",
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: paddingSize),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      SizedBox(width: paddingSize * 0.2),
                      Expanded(
                        child: AppCustomTexts(
                          TextName: item.location ?? "Unknown Location",
                          textStyle: textTheme.bodyMedium!.copyWith(
                            fontFamily: "Times New Roman",
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: paddingSize * 0.3),

                  // Salary
                  Row(
                    children: [
                      AppCustomTexts(
                        TextName: " ₹",
                        textStyle: textTheme.displayMedium!.copyWith(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      SizedBox(width: paddingSize * 0.3),
                      AppCustomTexts(
                        TextName: " ${item.salaryRange ?? "Not specified"}",
                        textStyle: textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Times New Roman",
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: paddingSize * 0.9),

                  // View Detail
                  AppCustomTexts(
                    Textalign: TextAlign.right,
                    TextName: "View Detail",
                    textStyle: textTheme.displaySmall!.copyWith(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


}
