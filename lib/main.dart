import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparqly/app/apptheme/App Theme/App_Theme.dart';
import 'package:sparqly/app/apptheme/themecontroller/themeController.dart';
import 'package:sparqly/app/link_controller.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/modules/splash/views/splash_view.dart';
import 'app/modules/splash/controllers/subscriptionCheckController.dart';
import 'app/routes/app_pages.dart';
import 'app/services/location services/Location.dart';

// void main() async {
//   // 1. Flutter Engine Bindings
//   WidgetsFlutterBinding.ensureInitialized();

//   // 2. Storage initialization
//   await GetStorage.init();

//   // 3. Put Essential Controllers
//   Get.put(Themecontroller());

//   // LinkController ko yahan initialize karna zaroori hai
//   Get.put(LinkController(), permanent: true);

//   // 4. Heavy services
//   await Get.putAsync(() async => LocationAccesss(), permanent: true);
//   await Get.putAsync(
//     () async => SubscriptionCheckController(),
//     permanent: true,
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeController = Get.find<Themecontroller>();

//     return Obx(() {
//       return GetMaterialApp(
//         title: "Sparqly",
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.isLight(context),
//         darkTheme: AppTheme.isDark(context),
//         themeMode: themeController.theme,
//         initialRoute: Routes.SPLASH, // App hamesha Splash se shuru hogi
//         getPages: AppPage.routes,
//         defaultTransition: Transition.fade,
//       );
//     });
//   }
// }

///////////////// App Links /////////////
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();

//   // Core Controllers
//   Get.put(Themecontroller());

//   // LinkController initialize hote hi deep link check karega
//   Get.put(LinkController(), permanent: true);

//   // Non-blocking services
//   Get.put(LocationAccesss(), permanent: true);
//   Get.put(SubscriptionCheckController(), permanent: true);

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<Themecontroller>();

//     return Obx(() {
//       return GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: AppTheme.isLight(context),
//         darkTheme: AppTheme.isDark(context),
//         themeMode: controller.theme,
//         initialRoute: Routes.SPLASH,
//         getPages: AppPage.routes,
//       );
//     });
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Core Controllers
  Get.put(Themecontroller());
  Get.put(LinkController(), permanent: true);
  Get.put(LocationAccesss(), permanent: true);
  Get.put(SubscriptionCheckController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Themecontroller>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sparqly',
        theme: AppTheme.isLight(context),
        darkTheme: AppTheme.isDark(context),
        themeMode: controller.theme,
        initialRoute: Routes.SPLASH,
        getPages: AppPage.routes,

        //  Deep Link Fix: Jab app killed hai aur deep link se open hota hai,
        // Android deep link URL (e.g. /business/123) ko initial route bana deta hai.
        // Ye route getPages mein nahi milta → black screen!
        // unknownRoute splash pe redirect karega → splash normally chalega
        unknownRoute: GetPage(
          name: '/unknown',
          page: () => const SplashView(),
          binding: SplashBinding(),
        ),

        // Handle null child during route transitions
        builder: (context, child) {
          return child ?? const Scaffold();
        },
      );
    });
  }
}
