import 'package:flutter/material.dart';
import '../../constants/App_Colors.dart';


class AppTheme {

 static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
     if (screenWidth < 600) {
      return baseFontSize;
    } else if (screenWidth < 1100) {
      return baseFontSize * 1.3;
    } else {
      return baseFontSize * 1.6;
    }
  }

  static ThemeData isDark(context) {
    const String montserratFont = "Montserrat";
    return ThemeData(


      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkmode,
      brightness: Brightness.dark,
      hintColor: AppColors.white,
      textTheme: TextTheme(
        bodySmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 11), color: AppColors.white),
        bodyMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 12), color: AppColors.white),
        bodyLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 13), color: AppColors.white),

        displaySmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 14), color: AppColors.white),
        displayMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 15), color: AppColors.white),
        displayLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 16), color: AppColors.white),

        headlineSmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 17), color: AppColors.white),
        headlineMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 18), color: AppColors.white),
        headlineLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 19), color: AppColors.white),

        titleSmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 20), color: AppColors.white),
        titleMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 21), color: AppColors.white),
        titleLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 22), color: AppColors.white),
      ),
      iconTheme: IconThemeData(color: AppColors.white, size: 26),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),



    );

  }

  static ThemeData isLight(context) {
    const String montserratFont = "Montserrat";
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldBc,
      brightness: Brightness.light,
      hintColor: AppColors.black,
      textTheme: TextTheme(
        bodySmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 11), color: AppColors.black),
        bodyMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 12), color: AppColors.black),
        bodyLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 13), color: AppColors.black),

        displaySmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 14), color: AppColors.black),
        displayMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 15), color: AppColors.black),
        displayLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 16), color: AppColors.black),

        headlineSmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 17), color: AppColors.black),
        headlineMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 18), color: AppColors.black),
        headlineLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 19), color: AppColors.black),

        titleSmall: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 20), color: AppColors.black),
        titleMedium: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 21), color: AppColors.black),
        titleLarge: TextStyle(
            fontFamily: montserratFont, fontSize: getResponsiveFontSize(context, 22), color: AppColors.black),
      ),
     // iconTheme: IconThemeData(color: AppColors.blackscaffoldcolor, size: 35),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

    );

  }
}
