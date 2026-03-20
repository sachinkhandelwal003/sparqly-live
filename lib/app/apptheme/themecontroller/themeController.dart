import 'package:flutter/material.dart';
import 'package:get/get.dart';

 class Themecontroller extends GetxController
 {
    RxBool isDark = false.obs;

    ThemeMode get theme => isDark.value ? ThemeMode.dark : ThemeMode.light;

    void changeTheme(bool val)
    {
      isDark.value = val;
    }
 }
