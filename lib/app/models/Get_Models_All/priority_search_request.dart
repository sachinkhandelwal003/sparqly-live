import 'dart:async';
import 'package:get/get.dart';
import '../../services/api_services/apiServices.dart';
import '../../services/location services/Location.dart';
import '../../widgets/Custom_Widgets/App_Filters.dart';

class PrioritySearchRequest {
  final String type;
  final String keyword;

  PrioritySearchRequest({
    required this.type,
    required this.keyword,
  });

  Map<String, String> toQueryParams() {
    return {
      "type": type,
      "keyword": keyword,
    };
  }
}

class PrioritySearchController extends GetxController
    implements SearchFilterController {

  @override
  RxString selectedCategory = ''.obs;

  @override
  RxDouble selectedRadius = 0.0.obs;

  var hasInitialized = false.obs;

  RxString searchText = ''.obs;
  RxBool isLoading = false.obs;
  RxList<dynamic> results = <dynamic>[].obs;

  Timer? _debounce;
  List<dynamic> _fallbackList = [];
  String searchType = "business";

  void setFallbackList(
      List<Map<String, dynamic>> list, {
        required String type,
      }) {
    searchType = type;

    _fallbackList
      ..clear()
      ..addAll(list);

    results
      ..clear()
      ..addAll(list);

    hasInitialized.value = true;
  }

  @override
  void updateSearch(String value) {
    searchText.value = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performPrioritySearch();
    });
  }

  @override
  void updateCategory(String value) {
    selectedCategory.value = value;
  }

  @override
  void updateRadius(double value) {
    selectedRadius.value = value;
  }

  Future<void> _performPrioritySearch() async {
    try {
      isLoading.value = true;

      if (searchText.value.trim().isEmpty) {
        results.assignAll(_fallbackList);
        return;
      }

      final request = PrioritySearchRequest(
        type: searchType,
        keyword: searchText.value.trim(),
      );

      final response = await ApiServices().prioritySearch(request);

      if (response is Map && response["status"] == true) {
        results.assignAll(response["data"]);
      } else {
        results.clear();
      }
    } catch (e) {
      results.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}

