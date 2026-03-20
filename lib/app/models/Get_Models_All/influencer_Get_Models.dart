class InfluencerListResponse {
  final bool status;
  final String message;
  final List<InfluencerData> data;

  InfluencerListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InfluencerListResponse.fromJson(Map<String, dynamic> json) {
    return InfluencerListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => InfluencerData.fromJson(e))
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

class InfluencerData {
  final int id;
  final String name;
  final String profession;
  final String bio;
  final String niche;
  final String image;
  final String location;
  final String latitude;
  final String longitude;
  final String? websiteLink;
  final String instagram;
  final String youtube;
  final String facebook;
  final String linkedin;
  final String mobile;
  final int status;

  InfluencerData({
    required this.id,
    required this.name,
    required this.profession,
    required this.bio,
    required this.niche,
    required this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.websiteLink,
    required this.instagram,
    required this.youtube,
    required this.facebook,
    required this.linkedin,
    required this.mobile,
    required this.status,
  });

  factory InfluencerData.fromJson(Map<String, dynamic> json) {
    return InfluencerData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      bio: json['bio'] ?? '',
      niche: json['niche'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      websiteLink: json['website_link'],
      instagram: json['instagram'] ?? '',
      youtube: json['youtube'] ?? '',
      facebook: json['facebook'] ?? '',
      linkedin: json['linkedin'] ?? '',
      mobile: json['mobile'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    };
  }
}
