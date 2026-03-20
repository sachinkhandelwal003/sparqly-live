import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_All_List.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import '../../../constants/App_Colors.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  CategoriesView({super.key});

  final CategoriesController controller = Get.put(CategoriesController());
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: AppAllList.categoryList.length,
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.03,
                vertical: mediaQuery.size.height * 0.015,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      print("Tapped Business");
                      dashboardController.goToPage(11);
                    } else if (index == 1) {
                      dashboardController.goToPage(12);
                    } else if (index == 2) {
                      dashboardController.goToPage(13);
                    }
                  },
                  child: Container(
                    height: mediaQuery.size.height * 0.22,
                    margin: EdgeInsets.only(
                      bottom: mediaQuery.size.height * 0.02,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AppAllList.categoryImg[index],
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(
                                mediaQuery.size.width * 0.03,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      mediaQuery.size.width * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: constraints.maxWidth * 0.04,
                                      child: Image.asset(
                                        AppAllList.categoryListIcon[index],
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.055,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: mediaQuery.size.width * 0.02),
                                  AppCustomTexts(
                                    TextName: AppAllList.categoryList[index],
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Times New Roman",
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
