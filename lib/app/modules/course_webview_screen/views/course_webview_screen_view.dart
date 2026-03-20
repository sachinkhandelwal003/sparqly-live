import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/course_webview_screen_controller.dart';

class CourseWebviewScreenView
    extends GetView<CourseWebviewScreenController> {
  const CourseWebviewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (!controller.isWebViewReady.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              WebViewWidget(
                controller: controller.webViewController!,
              ),
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        }),
      ),
    );
  }
}
