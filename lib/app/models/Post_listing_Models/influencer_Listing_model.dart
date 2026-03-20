class InfluencerResponse {
  final bool status;
  final String message;
  final InfluencerData? data;

  InfluencerResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory InfluencerResponse.fromJson(Map<String, dynamic> json) {
    return InfluencerResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? InfluencerData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class InfluencerData {
  final int appUserId;
  final String name;
  final String profession;
  final String bio;
  final String niche;
  final String? image;
  final String location;
  final String latitude;
  final String longitude;
  final String websiteLink;
  final String instagram;
  final String youtube;
  final String facebook;
  final String linkedin;
  final String mobile;
  final int status;
  final String updatedAt;
  final String createdAt;
  final int id;

  InfluencerData({
    required this.appUserId,
    required this.name,
    required this.profession,
    required this.bio,
    required this.niche,
    this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.websiteLink,
    required this.instagram,
    required this.youtube,
    required this.facebook,
    required this.linkedin,
    required this.mobile,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory InfluencerData.fromJson(Map<String, dynamic> json) {
    return InfluencerData(
      appUserId: json['app_user_id'] ?? 0,
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      bio: json['bio'] ?? '',
      niche: json['niche'] ?? '',
      image: json['image'],
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      websiteLink: json['website_link'] ?? '',
      instagram: json['instagram'] ?? '',
      youtube: json['youtube'] ?? '',
      facebook: json['facebook'] ?? '',
      linkedin: json['linkedin'] ?? '',
      mobile: json['mobile'] ?? '',
      status: json['status'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_user_id': appUserId,
      'name': name,
      'profession': profession,
      'bio': bio,
      'niche': niche,
      'image': image,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'website_link': websiteLink,
      'instagram': instagram,
      'youtube': youtube,
      'facebook': facebook,
      'linkedin': linkedin,
      'mobile': mobile,
      'status': status,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}

class CategoryResponseInfluencer {
  bool status;
  String message;
  List<CategoryInfluencer> data;

  CategoryResponseInfluencer({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponseInfluencer.fromJson(Map<String, dynamic> json) {
    return CategoryResponseInfluencer(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CategoryInfluencer>.from(json['data'].map((x) => CategoryInfluencer.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoryInfluencer {
  int id;
  String categoryName;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  CategoryInfluencer({
    required this.id,
    required this.categoryName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryInfluencer.fromJson(Map<String, dynamic> json) {
    return CategoryInfluencer(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_name': categoryName,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

