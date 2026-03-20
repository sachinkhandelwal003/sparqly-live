import 'package:get/get.dart';

import '../controllers/ad_listings_controller.dart';

class AdListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdListingsController>(
      () => AdListingsController(),
    );
  }
}
