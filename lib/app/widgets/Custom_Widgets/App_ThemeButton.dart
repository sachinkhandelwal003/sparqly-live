import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../apptheme/themecontroller/themeController.dart';
import '../../constants/App_Assets.dart';
import 'App_Custom_Container.dart';

class AppThemebutton extends StatelessWidget {

   AppThemebutton({super.key});
  final controllerTheme = Get.find<Themecontroller>();
  @override
  Widget build(BuildContext context) {
    return  // Theme switcher
      Obx(
            () => AppCustomContainer(
          height: 31,
          width: 61,
          color: Colors.transparent,
          borderradius: 5,
          child: Stack(
            children: [
              controllerTheme.isDark.value
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppAssets.night,
                  fit: BoxFit.fill,
                  height: 50,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppAssets.day,
                  fit: BoxFit.fitWidth,
                ),
              ),
              AnimatedAlign(
                alignment: controllerTheme.isDark.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                duration: const Duration(milliseconds: 400),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    controllerTheme.changeTheme(
                        !controllerTheme.isDark.value);
                  },
                  child: AppCustomContainer(
                    height: 25,
                    width: 30,
                    color: Colors.transparent,
                    boxshape: BoxShape.circle,
                    child: controllerTheme.isDark.value
                        ? Image.asset(AppAssets.moon, fit: BoxFit.fill)
                        : Image.asset(AppAssets.sun, fit: BoxFit.fill),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
