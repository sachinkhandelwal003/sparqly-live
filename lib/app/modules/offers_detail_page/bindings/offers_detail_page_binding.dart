import 'package:get/get.dart';

import '../controllers/offers_detail_page_controller.dart';

class OffersDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OffersDetailPageController>(
      () => OffersDetailPageController(),
    );
  }
}
