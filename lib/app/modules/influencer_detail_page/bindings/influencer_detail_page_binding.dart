import 'package:get/get.dart';

import '../controllers/influencer_detail_page_controller.dart';

class InfluencerDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfluencerDetailPageController>(
      () => InfluencerDetailPageController(),
    );
  }
}
