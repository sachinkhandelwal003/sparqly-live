class CourseDetailPageModel {
  bool status;
  String message;
  CourseDetailData data;

  CourseDetailPageModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CourseDetailPageModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailPageModel(
        status: json["status"],
        message: json["messsage"],
        data: CourseDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messsage": message,
    "data": data.toJson(),
  };
}

class CourseDetailData {
  int id;
  int UserId;
  String courseTitle;
  String instructor;
  String description;
  String courseCategory;
  String language;
  String image;
  String level;
  String duration;
  String price;
  String accessDuration;
  String days;
  String status;
  String mobile;
  List<Chapter> chapters;

  CourseDetailData({
    required this.id,
    required this.UserId,
    required this.courseTitle,
    required this.instructor,
    required this.description,
    required this.courseCategory,
    required this.language,
    required this.image,
    required this.level,
    required this.duration,
    required this.price,
    required this.accessDuration,
    required this.days,
    required this.status,
    required this.mobile,
    required this.chapters,
  });

  factory CourseDetailData.fromJson(Map<String, dynamic> json) => CourseDetailData(
    id: json["id"],
    UserId: json["app_user_id"],
    courseTitle: json["course_title"],
    instructor: json["instructor"],
    description: json["description"],
    courseCategory: json["course_category"],
    language: json["language"],
    image: json["image"],
    level: json["level"],
    duration: json["duration"],
    price: json["price"],
    accessDuration: json["access_duration"],
    days: json["days"],
    status: json["status"],
    mobile: json["mobile"],
    chapters: List<Chapter>.from(
        json["chapters"].map((x) => Chapter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": UserId,
    "course_title": courseTitle,
    "instructor": instructor,
    "description": description,
    "course_category": courseCategory,
    "language": language,
    "image": image,
    "level": level,
    "duration": duration,
    "price": price,
    "access_duration": accessDuration,
    "days": days,
    "status": status,
    "mobile": mobile,
    "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
  };
}

class Chapter {
  int id;
  String chapterTitle;
  int position;
  List<Module> modules;

  Chapter({
    required this.id,
    required this.chapterTitle,
    required this.position,
    required this.modules,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json["id"],
    chapterTitle: json["chapter_title"],
    position: json["position"],
    modules:
    List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chapter_title": chapterTitle,
    "position": position,
    "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
  };
}

class Module {
  int id;
  String type;
  String moduleTitle;
  int modulePosition;
  ModuleDetails details;

  Module({
    required this.id,
    required this.type,
    required this.moduleTitle,
    required this.modulePosition,
    required this.details,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    id: json["id"],
    type: json["type"],
    moduleTitle: json["module_title"],
    modulePosition: json["module_position"],
    details: ModuleDetails.fromJson(json["details"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "module_title": moduleTitle,
    "module_position": modulePosition,
    "details": details.toJson(),
  };
}

class ModuleDetails {
  String? description;
  String? videoLink;
  String? documentPath;

  ModuleDetails({this.description, this.videoLink, this.documentPath});

  factory ModuleDetails.fromJson(Map<String, dynamic> json) => ModuleDetails(
    description: json["description"],
    videoLink: json["video_link"],
    documentPath: json["document_path"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "video_link": videoLink,
    "document_path": documentPath,
  };
}
