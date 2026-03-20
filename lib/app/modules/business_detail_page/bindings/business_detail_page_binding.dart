import 'package:get/get.dart';

import '../controllers/business_detail_page_controller.dart';

class BusinessDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessDetailPageController>(
      () => BusinessDetailPageController(),
    );
  }
}
