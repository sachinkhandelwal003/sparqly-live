class CourseResponse {
  bool status;
  String message;
  Course course;

  CourseResponse({
    required this.status,
    required this.message,
    required this.course,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      status: json['status'],
      message: json['message'],
      course: Course.fromJson(json['course']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'course': course.toJson(),
  };
}

class Course {
  int appUserId;
  String courseTitle;
  String instructor;
  String description;
  String courseCatId;
  String language;
  String level;
  String duration;
  String price;
  String accessDuration;
  String days;
  String? image;
  String mobile;
  int status;
  String updatedAt;
  String createdAt;
  int id;
  List<Chapter> chapters;

  Course({
    required this.appUserId,
    required this.courseTitle,
    required this.instructor,
    required this.description,
    required this.courseCatId,
    required this.language,
    required this.level,
    required this.duration,
    required this.price,
    required this.accessDuration,
    required this.days,
    this.image,
    required this.mobile,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.chapters,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var chaptersList = json['chapters'] as List;
    List<Chapter> chapterObjs = chaptersList.map((c) => Chapter.fromJson(c)).toList();

    return Course(
      appUserId: json['app_user_id'],
      courseTitle: json['course_title'],
      instructor: json['instructor'],
      description: json['description'],
      courseCatId: json['course_cat_id'],
      language: json['language'],
      level: json['level'],
      duration: json['duration'],
      price: json['price'],
      accessDuration: json['access_duration'],
      days: json['days'],
      image: json['image'],
      mobile: json['mobile'],
      status: json['status'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      chapters: chapterObjs,
    );
  }

  Map<String, dynamic> toJson() => {
    'app_user_id': appUserId,
    'course_title': courseTitle,
    'instructor': instructor,
    'description': description,
    'course_cat_id': courseCatId,
    'language': language,
    'level': level,
    'duration': duration,
    'price': price,
    'access_duration': accessDuration,
    'days': days,
    'image': image,
    'mobile': mobile,
    'status': status,
    'updated_at': updatedAt,
    'created_at': createdAt,
    'id': id,
    'chapters': chapters.map((c) => c.toJson()).toList(),
  };
}

class Chapter {
  int id;
  int courseId;
  String chapterTitle;
  int position;
  String createdAt;
  String updatedAt;
  List<Module> modules;

  Chapter({
    required this.id,
    required this.courseId,
    required this.chapterTitle,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.modules,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    var modulesList = json['modules'] as List;
    List<Module> moduleObjs = modulesList.map((m) => Module.fromJson(m)).toList();

    return Chapter(
      id: json['id'],
      courseId: json['course_id'],
      chapterTitle: json['chapter_title'],
      position: json['position'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      modules: moduleObjs,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'course_id': courseId,
    'chapter_title': chapterTitle,
    'position': position,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'modules': modules.map((m) => m.toJson()).toList(),
  };
}

class Module {
  int id;
  int chapterId;
  String type;
  String moduleTitle;
  int modulePosition;
  String createdAt;
  String updatedAt;
  ModuleDetails details;

  Module({
    required this.id,
    required this.chapterId,
    required this.type,
    required this.moduleTitle,
    required this.modulePosition,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      chapterId: json['chapter_id'],
      type: json['type'],
      moduleTitle: json['module_title'],
      modulePosition: json['module_position'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      details: ModuleDetails.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'chapter_id': chapterId,
    'type': type,
    'module_title': moduleTitle,
    'module_position': modulePosition,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'details': details.toJson(),
  };
}

class ModuleDetails {
  int id;
  int moduleId;
  String? description;
  String? videoLink;
  String? documentPath;
  String createdAt;
  String updatedAt;

  ModuleDetails({
    required this.id,
    required this.moduleId,
    this.description,
    this.videoLink,
    this.documentPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModuleDetails.fromJson(Map<String, dynamic> json) {
    return ModuleDetails(
      id: json['id'],
      moduleId: json['module_id'],
      description: json['description'],
      videoLink: json['video_link'],
      documentPath: json['document_path'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'module_id': moduleId,
    'description': description,
    'video_link': videoLink,
    'document_path': documentPath,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class CourseCategoryResponse {
  final bool status;
  final String message;
  final List<CourseCategory> data;

  CourseCategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CourseCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CourseCategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CourseCategory.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CourseCategory {
  final int id;
  final String name;
  final int status;

  CourseCategory({
    required this.id,
    required this.name,
    required this.status,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

