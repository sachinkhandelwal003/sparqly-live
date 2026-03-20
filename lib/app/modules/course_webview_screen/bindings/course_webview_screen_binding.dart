import 'package:get/get.dart';

import '../controllers/course_webview_screen_controller.dart';

class CourseWebviewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseWebviewScreenController>(
      () => CourseWebviewScreenController(),
    );
  }
}
