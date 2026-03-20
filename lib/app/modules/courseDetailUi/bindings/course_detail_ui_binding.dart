import 'package:get/get.dart';

import '../controllers/course_detail_ui_controller.dart';

class CourseDetailUiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseDetailUiController>(
      () => CourseDetailUiController(),
    );
  }
}
