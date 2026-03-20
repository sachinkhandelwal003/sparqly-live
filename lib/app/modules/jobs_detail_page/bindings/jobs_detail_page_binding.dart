import 'package:get/get.dart';

import '../controllers/jobs_detail_page_controller.dart';

class JobsDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobsDetailPageController>(
      () => JobsDetailPageController(),
    );
  }
}
