import 'package:get/get.dart';

import '../controllers/offers_listings_controller.dart';

class OffersListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OffersListingsController>(
      () => OffersListingsController(),
    );
  }
}
