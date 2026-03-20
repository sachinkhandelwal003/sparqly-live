import 'package:get/get.dart';

import '../controllers/business_listings_controller.dart';

class BusinessListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessListingsController>(
      () => BusinessListingsController(),
    );
  }
}
