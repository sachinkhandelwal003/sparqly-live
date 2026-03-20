import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/App_Assets.dart';
import '../../constants/App_Colors.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../routes/app_pages.dart';

class AppHomebar extends StatelessWidget implements PreferredSizeWidget {
  AppHomebar({super.key});

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final storage = GetStorage();
    final token = storage.read('auth_token');

    // Responsive sizing
    final bool isSmallScreen = size.width < 360;
    final double iconSize = isSmallScreen ? 20 : 24;
    final double loginIconSize = isSmallScreen ? 16 : 20;
    final double horizontalPadding = isSmallScreen ? 6 : 8;
    final double verticalPadding = isSmallScreen ? 2.5 : 5;
    final double logoWidth = size.width * (isSmallScreen ? 0.2 : 0.25);

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: true, // keeps the drawer icon
      centerTitle: true,
      elevation: 0,
      title: SizedBox(
        width: logoWidth,
        child: Image.asset(
          AppAssets.otpLogo,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: token != null && token.toString().isNotEmpty
              ? IconButton(
            onPressed: () {
              dashboardController.goToPage(15); // ChatListScreen
            },
            icon: Icon(
              Icons.chat_bubble_outline,
              size: iconSize,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
          )
              : GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.OTP);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.login,
                    color: Colors.white,
                    size: loginIconSize,
                  ),
                  SizedBox(width: horizontalPadding / 2),
                  Text(
                    "Login",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
