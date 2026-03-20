import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/Post_listing_Models/course_Listing_models.dart';
import '../../../services/api_services/apiServices.dart';

class CourseListingsController extends GetxController {
  var courseImage = Rxn<File>();
  var selectedDays = 1.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var title = "".obs;
  var instructor = "".obs;
  var description = "".obs;
  var category = "".obs;
  var language = "".obs;
  var level = "".obs;
  var duration = "".obs;
  var price = "".obs;
  var accessDurationn = "".obs;
  var mobile = "".obs;
  final _categoryService = ApiServices();
  var categories = <CourseCategory>[].obs;
  var selectedCategory = Rxn<CourseCategory>();
  var languages = ["English", "Hindi", "Spanish", "French"];
  var levels = ["Beginner", "Intermediate", "Advanced"];
  var accessDuration = ["Days", "Month", "Year", "Lifetime"];
  var chapters = <Chapter>[].obs;

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final result = await _categoryService.fetchCourseDropdown();
      categories.assignAll(result);
      if (categories.isNotEmpty) {
        selectedCategory.value = categories.first;
      }
      print("Fetched categories: ${categories.length}");
    } catch (e) {
      errorMessage.value = "Failed to load categories: $e";
      print("Failed to load categories: $e");
    } finally {
      isLoading.value = false;
    }
  }


  void addChapter() => chapters.add(Chapter());
  void removeChapter(int index) {
    if (index >= 0 && index < chapters.length) chapters.removeAt(index);
  }
  void setDays(int days) => selectedDays.value = days;
  Future<void> pickCourseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 1024, maxHeight: 1024);
    if (pickedFile != null) courseImage.value = File(pickedFile.path);
  }
  Future<void> pickDocument(Chapter chapter, int docIndex) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
      withData: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path != null) {
        chapter.documentModules[docIndex]["file"] = path;
        chapter.documentModules.refresh();
      }
    }
  }
  final ApiServices api = ApiServices();
  void addCurriculumFields({
    required List<Chapter> chapters,
    required Map<String, String> extraFields,
    required Map<String, File> extraFiles,
  }) {
    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      int moduleIndex = 0;
      for (var module in chapter.textModules) {
        if ((module["text"] ?? "").isNotEmpty) {
          extraFields[
          "curriculum[$i][modules][$moduleIndex][description]"
          ] = module["text"]!;
        }
        moduleIndex++;
      }
      for (var module in chapter.videoModules) {
        if ((module["text"] ?? "").isNotEmpty) {
          extraFields[
          "curriculum[$i][modules][$moduleIndex][video_link]"
          ] = module["text"]!;
        }
        moduleIndex++;
      }

      for (var module in chapter.documentModules) {
        if ((module["file"] ?? "").isNotEmpty) {
          extraFiles[
          "curriculum[$i][modules][$moduleIndex][document_file]"
          ] = File(module["file"]!);
        }
        moduleIndex++;
      }
    }
  }

  Future<void> submitCourse() async {
    if (title.value.isEmpty || instructor.value.isEmpty || description.value.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }
    if (selectedCategory.value == null) {
      Get.snackbar("Error", "Please select a category");
      return;
    }
    isLoading.value = true;
    errorMessage.value = "";

    try {
      final courseData = {
        "course_title": title.value,
        "instructor": instructor.value,
        "description": description.value,
        "course_cat_id": selectedCategory.value?.id.toString() ?? "",
        "language": language.value,
        "level": level.value,
        "duration": duration.value,
        "price": price.value,
        "access_duration": accessDurationn.value,
        "mobile": mobile.value,
        "days": selectedDays.value.toString(),
        "curriculum": chapters.map((c) {
          return {
            "chapter_title": c.title.value,
            "modules": [

              ...c.textModules.map((m) => {
                "type": "text",
                "module_title": m["title"] ?? "",
                "details": {
                  "description": m["description"] ?? "",
                  "video_link": null,
                  "document_path": null
                }
              }),

              ...c.videoModules.map((m) => {
                "type": "video",
                "module_title": m["title"] ?? "",
                "details": {
                  "description": null,
                  "video_link": m["video_link"] ?? "",
                  "document_path": null
                }
              }),

              ...c.documentModules.map((m) => {
                "type": "document",
                "module_title": m["title"] ?? "",
                "details": {
                  "description": null,
                  "video_link": null,
                  "document_path": null
                }
              }),

            ],
          };
        }).toList(),
        // "curriculum": chapters.map((c) {
        //   return {
        //     "chapter_title": c.title.value,
        //     "modules": [
        //       ...c.textModules.map((m) => {
        //         "type": "text",
        //         "module_title": m["title"] ?? "",
        //       }),
        //       ...c.videoModules.map((m) => {
        //         "type": "video",
        //         "module_title": m["title"] ?? "",
        //       }),
        //       ...c.documentModules.map((m) => {
        //         "type": "document",
        //         "module_title": m["title"] ?? "",
        //       }),
        //     ],
        //   };
        // }).toList(),

      };

      print(" Course Data JSON: ${jsonEncode(courseData)}");

      Map<String, File> extraFiles = {};
      Map<String, String> extraFields = {};

      addCurriculumFields(
        chapters: chapters,
        extraFields: extraFields,
        extraFiles: extraFiles,
      );

      extraFields.forEach((k, v) => print(" FIELD: $k => $v"));
      extraFiles.forEach((k, v) => print(" FILE: $k => ${v.path}"));

      if (extraFiles.isNotEmpty) {
        extraFiles.forEach((key, file) {
          print(" Extra File: $key -> ${file.path}");
        });
      } else {
        print(" No extra files selected");
      }

      final response = await api.postCourse<CourseResponse>(
        endpoint: "course/store",
        body: courseData,
        fromJson: (json) => CourseResponse.fromJson(json),
        imagePath: courseImage.value?.path,
        extraFiles: extraFiles.isEmpty ? null : extraFiles,
      );

      if (response != null && response.status == true) {
        Get.snackbar("Success", response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        print("Course Created: ${response.toJson()}");
      } else {
        errorMessage.value = response?.message ?? "Failed to create course";
        print("API Error: ${errorMessage.value}");
      }
    } catch (e, s) {
      errorMessage.value = "Exception: $e";
      print("Exception: $e\nStacktrace: $s");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}

class Chapter {
  var title = "".obs;
  var selectedModule = "text".obs;
  var textModules = <Map<String, String>>[].obs;
  var videoModules = <Map<String, String>>[].obs;
  var documentModules = <Map<String, String>>[].obs;
  void addTextModule() => textModules.add({"title": "", "text": ""});
  void addVideoModule() => videoModules.add({"title": "", "text": ""});
  void addDocumentModule() => documentModules.add({"title": "", "file": ""});
}
