import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/App_Colors.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../models/Get_Models_All/course_Get_Models.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../splash/controllers/subscriptionCheckController.dart';
import '../controllers/courses_controller.dart';


class CoursesView extends StatefulWidget {
  const CoursesView({super.key});

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  final controller = Get.put(CoursesController());
  final dashboardController = Get.find<DashboardController>();

  // // ✅ USE NEW GLOBAL CONTROLLER
  // final SubscriptionCheckController subscriptionController =
  // Get.find<SubscriptionCheckController>();

  // @override
  // void initState() {
  //   super.initState();
  //   subscriptionController.loadData();    // ✅ Runs only once
  // }

  @override
  Widget build(BuildContext context) {

    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;

          return RefreshIndicator(
            onRefresh: () async {
               controller.fetchCourses();
            },
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.01),
                Obx(() {
                  final categories = <String>["All"];
                  categories.addAll(
                    controller.coursesData
                        .map((e) => e.courseCategory ?? "Other")
                        .where((e) => e.isNotEmpty)
                        .toSet()
                        .toList(),
                  );

                  return SearchAndFilterBar(
                    controller: controller.prioritySearchController,
                    categories: categories,
                    searchHint: "Search courses...",
                    categoryLabel: "Category",
                    showDistanceSlider: false,
                  );

                }),

                // PAID / FREE DROPDOWN (SAME STYLE AS CATEGORY)
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Obx(
                //         () => DropdownButtonFormField<String>(
                //       value: controller.selectedPriceType.value == "All"
                //           ? null
                //           : controller.selectedPriceType.value,
                //
                //       items: const [
                //         DropdownMenuItem(
                //           value: "All",
                //           child: Text(
                //             "All",
                //             style: TextStyle(
                //               fontSize: 12,
                //               // fontFamily: "Times New Roman",
                //             ),
                //           ),
                //         ),
                //         DropdownMenuItem(
                //           value: "Paid",
                //           child: Text(
                //             "Paid",
                //             style: TextStyle(
                //               fontSize: 12,
                //               // fontFamily: "Times New Roman",
                //             ),
                //           ),
                //         ),
                //         DropdownMenuItem(
                //           value: "Free",
                //           child: Text(
                //             "Free",
                //             style: TextStyle(
                //               fontSize: 12,
                //               // fontFamily: "Times New Roman",
                //             ),
                //           ),
                //         ),
                //       ],
                //
                //       onChanged: (value) {
                //         if (value != null) {
                //           controller.selectedPriceType.value = value;
                //         }
                //       },
                //
                //       dropdownColor: Colors.white,
                //       isDense: true,
                //
                //       style: const TextStyle(
                //         fontSize: 12,
                //         color: Colors.black,
                //         // fontFamily: "Times New Roman",
                //       ),
                //
                //       decoration: InputDecoration(
                //         labelText: "Price Type",
                //         labelStyle: const TextStyle(
                //           fontSize: 11,
                //           fontFamily: "Times New Roman",
                //         ),
                //         contentPadding:
                //         const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(12),
                //           borderSide: BorderSide(color: AppColors.dividercolor),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(12),
                //           borderSide:
                //           BorderSide(color: AppColors.dividercolor, width: 2),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),



                // Course List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoadingCourse.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.errorMessageCourse.isNotEmpty) {
                      return Center(
                        child: Text(controller.errorMessageCourse.value),
                      );
                    }

                    if (controller.coursesData.isEmpty) {
                      return const Center(child: Text("No courses found"));
                    }

                    final rawList =
                    controller.prioritySearchController.results.isNotEmpty
                        ? controller.prioritySearchController.results
                        .map((e) => CoursePage.fromJson(e))
                        .toList()
                        : controller.coursesData;

                    final items = rawList.where((course) {
                      return controller.selectedCategory.value == "All" ||
                          controller.selectedCategory.value.isEmpty ||
                          course.courseCategory.toLowerCase() ==
                              controller.selectedCategory.value.toLowerCase();
                    }).toList();

                    if (items.isEmpty) {
                      return const Center(child: Text("No courses found"));
                    }
                    {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {



                          final course = items[index];


                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                  controller.selectedId.value = course.id;
                                  dashboardController.goToPage(21);

                              },
                              child: AppCustomContainer(
                                borderradius: 12,
                                child: Card(
                                  color: AppColors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          course.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: screenHeight * 0.22,
                                          errorBuilder: (_, __, ___) => Container(
                                            height: screenHeight * 0.20,
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.005),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 13.0, left: 25, bottom: 25, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            AppCustomTexts(
                                              TextName: course.courseTitle,
                                              textStyle: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLine: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            AppCustomTexts(
                                              TextName: course.instructor,
                                              textStyle: TextStyle(
                                                  fontSize: screenWidth * 0.035,
                                                  color: Colors.grey,
                                                  fontFamily: "Times New Roman",
                                                  fontWeight: FontWeight.w600),
                                              maxLine: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AppCustomTexts(
                                                  TextName: course.duration,
                                                  textStyle: TextStyle(
                                                      fontSize: screenWidth * 0.038,
                                                      color: Colors.black54,
                                                      fontFamily: "Times New Roman",
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                AppCustomButton(
                                                  color: AppColors.dividercolor.withOpacity(0.3),
                                                  borderradius: 10,
                                                  action: () {

                                                  },
                                                  CustomName: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: AppCustomTexts(
                                                      TextName: course.level,
                                                      textStyle: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "Times New Roman"),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            AppCustomTexts(
                                              TextName: "₹${course.price}",
                                              textStyle: TextStyle(
                                                  fontSize: screenWidth * 0.045,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green,
                                                  fontFamily: "Times New Roman"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
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
