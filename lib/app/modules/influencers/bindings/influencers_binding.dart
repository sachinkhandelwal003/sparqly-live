import 'package:get/get.dart';

import '../controllers/influencers_controller.dart';

class InfluencersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfluencersController>(
      () => InfluencersController(),
    );
  }
}
