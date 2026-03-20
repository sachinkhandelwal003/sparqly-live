import 'package:get/get.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';

import '../../../models/Get_Models_All/getall_course.dart';

class MyCoursesController extends GetxController {
  var isLoading = false.obs;
  var courseList = <AllCourseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCourses();
  }

  void getCourses() async {
    try {
      isLoading(true);

      final data = await ApiServices().fetchAllCourses();

      courseList.value =
          data.map((e) => AllCourseModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
