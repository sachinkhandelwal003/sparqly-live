class JobCreateResponse {
  final bool status;
  final String message;
  final JobData? data;

  JobCreateResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory JobCreateResponse.fromJson(Map<String, dynamic> json) {
    return JobCreateResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? JobData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class JobData {
  final int appUserId;
  final String title;
  final String companyName;
  final String jobType;
  final String location;
  final String? image;
  final String description;
  final String latitude;
  final String longitude;
  final String salaryRange;
  final String applicationLink;
  final String mobile;
  final int status;
  final String updatedAt;
  final String createdAt;
  final int id;

  JobData({
    required this.appUserId,
    required this.title,
    required this.companyName,
    required this.jobType,
    required this.location,
    this.image,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.salaryRange,
    required this.applicationLink,
    required this.mobile,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      appUserId: json['app_user_id'] ?? 0,
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      jobType: json['job_type'] ?? '',
      location: json['location'] ?? '',
      image: json['image'],
      description: json['description'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      salaryRange: json['salary_range'] ?? '',
      applicationLink: json['application_link'] ?? '',
      mobile: json['mobile'] ?? '',
      status: json['status'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "app_user_id": appUserId,
      "title": title,
      "company_name": companyName,
      "job_type": jobType,
      "location": location,
      "image": image,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
      "salary_range": salaryRange,
      "application_link": applicationLink,
      "mobile": mobile,
      "status": status,
      "updated_at": updatedAt,
      "created_at": createdAt,
      "id": id,
    };
  }
}
