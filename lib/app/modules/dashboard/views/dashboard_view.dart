import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/app_homebar.dart';
import '../../../apptheme/themecontroller/themeController.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key});

  final controllerTheme = Get.find<Themecontroller>();

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0;
          return;
        }
        SystemNavigator.pop();
      },
      child: AppCustomScaffold(
        drawer: ProfileView(),
        customAppBar: AppHomebar(),
        BodyWidget: Obx(
              () => controller.pages[controller.selectedIndex.value](),
        ),

        floatingActionButton: isKeyboardOpen
            ? null
            : FloatingActionButton(
          elevation: 2,
          shape: const CircleBorder(),
          onPressed: () => controller.goToPage(2),
          backgroundColor: AppColors.floatingbuttondashboard,
          child: const Icon(
            CupertinoIcons.add,
            size: 26,
            color: Colors.white,
          ),
        ),


        BottomBar: Obx(
              () => BottomAppBar(
                height: 66,
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: CupertinoIcons.home,
                    label: "Home",
                    index: 0,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: CupertinoIcons.square_grid_2x2,
                    label: "Categories",
                    index: 1,
                    context: context,
                  ),
                  const SizedBox(width: 40), // gap for FAB
                  _buildNavItem(
                    icon: CupertinoIcons.gift,
                    label: "Offers",
                    index: 3,
                    context: context,
                  ),
                  _buildNavItem(
                    icon: CupertinoIcons.book,
                    label: "Courses",
                    index: 4,
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = controller.selectedIndex.value == index;

    return InkWell(
      onTap: () => controller.goToPage(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        // ✅ adds touch padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
            const SizedBox(height: 2),
            AppCustomTexts(
              TextName: label,
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected
                    ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                    : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
