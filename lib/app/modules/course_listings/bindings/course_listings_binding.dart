import 'package:get/get.dart';

import '../controllers/course_listings_controller.dart';

class CourseListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseListingsController>(
      () => CourseListingsController(),
    );
  }
}
