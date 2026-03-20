import 'package:get/get.dart';
import 'package:sparqly/app/models/Post_listing_Models/category_Models.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';

class CategoriesController extends GetxController {


  final ApiServices _service = ApiServices();

  var categories = <Category>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

}
