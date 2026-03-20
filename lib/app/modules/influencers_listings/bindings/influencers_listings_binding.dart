import 'package:get/get.dart';

import '../controllers/influencers_listings_controller.dart';

class InfluencersListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfluencersListingsController>(
      () => InfluencersListingsController(),
    );
  }
}
