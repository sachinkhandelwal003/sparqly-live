import 'dart:convert';

class JobDetailsResponse {
  final bool status;
  final String message;
  final JobDetails? data;

  JobDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory JobDetailsResponse.fromJson(Map<String, dynamic> json) {
    return JobDetailsResponse(
      status: json['status'] == true,
      message: json['messsage'] ?? '',
      data: json['data'] != null ? JobDetails.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "messsage": message,
      "data": data?.toJson(),
    };
  }

  static JobDetailsResponse fromRawJson(String str) =>
      JobDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class JobDetails {
  final int id;
  final int UserId;
  final String title;
  final String companyName;
  final String jobType;
  final String image;
  final String description;
  final String location;
  final String latitude;
  final String longitude;
  final String salaryRange;
  final String applicationLink;
  final int status;
  final String mobile;

  JobDetails({
    required this.id,
    required this.UserId,
    required this.title,
    required this.companyName,
    required this.jobType,
    required this.image,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.salaryRange,
    required this.applicationLink,
    required this.status,
    required this.mobile,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      id: json['id'] ?? 0,
      UserId: json['app_user_id'] ?? 0,
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      jobType: json['job_type'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      salaryRange: json['salary_range'] ?? '',
      applicationLink: json['application_link'] ?? '',
      status: json['status'] ?? 0,
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": UserId,
      "title": title,
      "company_name": companyName,
      "job_type": jobType,
      "image": image,
      "description": description,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "salary_range": salaryRange,
      "application_link": applicationLink,
      "status": status,
      "mobile": mobile,
    };
  }
}
