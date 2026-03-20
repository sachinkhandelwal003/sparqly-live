class CourseGetModels {
  bool status;
  String message;
  List<CoursePage> data;

  CourseGetModels({required this.status, required this.message, required this.data});

  factory CourseGetModels.fromJson(Map<String, dynamic> json) {
    return CourseGetModels(
      status: json['status'],
      message: json['message'],
      data: List<CoursePage>.from(json['data'].map((x) => CoursePage.fromJson(x))),
    );
  }
}

class CoursePage {
  int id;
  String courseTitle;
  String instructor;
  String image;
  String courseCategory;
  String duration;
  String price;
  String level;
  String status;

  CoursePage({
    required this.id,
    required this.courseTitle,
    required this.instructor,
    required this.image,
    required this.courseCategory,
    required this.duration,
    required this.price,
    required this.level,
    required this.status,
  });

  factory CoursePage.fromJson(Map<String, dynamic> json) {
    return CoursePage(
      id: json['id'] ?? 0,
      courseTitle: json['course_title'] ?? '',
      instructor: json['instructor'] ?? '',
      image: json['image'] ?? '',
      courseCategory: json['course_category'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price']?.toString() ?? '',
      level: json['level'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_title': courseTitle,
      'instructor': instructor,
      'image': image,
      'course_category': courseCategory,
      'duration': duration,
      'price': price,
      'level': level,
      'status': status,
    };
  }

}
