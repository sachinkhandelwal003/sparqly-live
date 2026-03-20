import 'dart:async';
import 'package:get/get.dart';
import 'package:sparqly/app/models/Get_Models_All/course_Get_Models.dart';
import '../../../models/Get_Models_All/priority_search_request.dart';
import '../../../models/Post_listing_Models/course_Listing_models.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../widgets/Custom_Widgets/App_Filters.dart';

class CoursesController extends GetxController implements SearchFilterController {
  // 🔍 Search + Filters
  var searchQuery = "".obs;
  var coursesList = <CoursePage>[].obs;
  var selectedCategory = "".obs;
  var selectedRadius = 10.0.obs;
  var selectedId = 0.obs;
  var categories = <CourseCategory>[].obs;
  var errorMessage = "".obs;
  RxString selectedPriceType = "All".obs;


  // ✅ Categories and courses from API
  var categoriesData = <CourseCategory>[].obs; // List<CourseCategory>
  var coursesData = <CoursePage>[].obs; // List<Course>

  // Loading/Error state
  var isLoadingCourse = false.obs;
  var errorMessageCourse = ''.obs;

  final PrioritySearchController prioritySearchController =
  Get.put(
    PrioritySearchController(),
    tag: "course",
  );

  /// Combined filtering
  List<CoursePage> get filteredJobs {
    return coursesData.where((course) {
      final query = searchQuery.value.toLowerCase();

      final title = (course.courseTitle ?? "").toLowerCase();
      final category = (course.courseCategory ?? "").toLowerCase();
      final price = (course.price ?? "").toLowerCase();
      final duration = (course.duration ?? "").toLowerCase();

      final matchesSearch =
          query.isEmpty || title.contains(query) || category.contains(query) || price.contains(query);

      final matchesCategory = selectedCategory.value == "All" ||
          selectedCategory.value.isEmpty ||
          category == selectedCategory.value.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }


  final ApiServices apiService = ApiServices();

  var isLoading = false.obs;

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final result = await apiService.fetchCourseDropdown();
      categories.assignAll(result);

      // Optional: select first category by default
      if (categories.isNotEmpty) {
        selectedCategory.value = categories.first.name;
      }

      print("Fetched categories: ${categories.length}");
    } catch (e) {
      errorMessage.value = "Failed to load categories: $e";
      print("Failed to load categories: $e");
    } finally {
      isLoading.value = false;
    }
  }


  //  Abstract controller methods
  @override
  void updateCategory(String value) => selectedCategory.value = value;

  @override
  void updateRadius(double value) => selectedRadius.value = value;

  @override
  void updateSearch(String value) => searchQuery.value = value;

  @override
  void onInit() {
    ever(prioritySearchController.selectedCategory, (value) {
      selectedCategory.value = value;
    });

    ever(prioritySearchController.selectedRadius, (value) {
      selectedRadius.value = value;
    });


    fetchCourses();

    super.onInit();
  }



  // Fetch courses dynamically from API
  void fetchCourses() async {
    try {
      isLoadingCourse.value = true;
      errorMessageCourse.value = '';

      final fetchedCourses = await apiService.fetchCourses();
      coursesData.assignAll(fetchedCourses);

      // ✅ Feed priority search fallback
      prioritySearchController.setFallbackList(
        fetchedCourses.map((e) => e.toJson()).toList(),
        type: "course",
      );

      print("✅ Courses fetched: ${fetchedCourses.length}");

    } catch (e) {
      errorMessageCourse.value = "Failed to load courses";
      print("❌ Course fetch error: $e");
    } finally {
      isLoadingCourse.value = false;
    }
  }


}
