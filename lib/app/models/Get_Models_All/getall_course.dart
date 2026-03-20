class AllCourseModel {
  final int id;
  final String title;
  final String image;
  final String detailUrl;

  AllCourseModel({
    required this.id,
    required this.title,
    required this.image,
    required this.detailUrl,
  });

  factory AllCourseModel.fromJson(Map<String, dynamic> json) {
    return AllCourseModel(
      id: json['id'],
      title: json['course_title'],
      image: json['image'],
      detailUrl: json['detail_url'],
    );
  }
}
