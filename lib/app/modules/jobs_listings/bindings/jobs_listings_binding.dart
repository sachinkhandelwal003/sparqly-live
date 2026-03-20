import 'package:get/get.dart';

import '../controllers/jobs_listings_controller.dart';

class JobsListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobsListingsController>(
      () => JobsListingsController(),
    );
  }
}
