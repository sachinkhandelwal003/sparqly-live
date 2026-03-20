class JobListResponse {
  final bool status;
  final String message;
  final List<JobData> data;

  JobListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobListResponse.fromJson(Map<String, dynamic> json) {
    return JobListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<JobData>.from(json['data'].map((x) => JobData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((x) => x.toJson()).toList(),
  };
}

class JobData {
  final int id;
  final String title;
  final String companyName;
  final String jobType;
  final String description;
  final String image;
  final String location;
  final String? latitude;
  final String? longitude;
  final String salaryRange;
  final String applicationLink;
  final String mobile;
  final int status;

  JobData({
    required this.id,
    required this.title,
    required this.companyName,
    required this.jobType,
    required this.description,
    required this.image,
    required this.location,
    this.latitude,
    this.longitude,
    required this.salaryRange,
    required this.applicationLink,
    required this.mobile,
    required this.status,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      jobType: json['job_type'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      salaryRange: json['salary_range'] ?? '',
      applicationLink: json['application_link'] ?? '',
      mobile: json['mobile'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'company_name': companyName,
    'job_type': jobType,
    'description': description,
    'image': image,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'salary_range': salaryRange,
    'application_link': applicationLink,
    'mobile': mobile,
    'status': status,
  };
}
