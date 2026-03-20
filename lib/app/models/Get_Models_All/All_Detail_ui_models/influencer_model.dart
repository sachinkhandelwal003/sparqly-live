import 'dart:convert';

class InfluencerDetailsResponse {
  final bool status;
  final String message;
  final InfluencerDetails? data;

  InfluencerDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory InfluencerDetailsResponse.fromJson(Map<String, dynamic> json) {
    return InfluencerDetailsResponse(
      status: json['status'] == true || json['status'] == 1,
      message: json['messsage'] ?? '',
      data: json['data'] != null
          ? InfluencerDetails.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "messsage": message,
      "data": data?.toJson(),
    };
  }

  /// Helpers
  static InfluencerDetailsResponse fromRawJson(String str) =>
      InfluencerDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}


class InfluencerDetails {
  final int id;
  final int userId;
  final String name;
  final String profession;
  final String bio;
  final String image;
  final String niche;
  final String location;
  final String latitude;
  final String longitude;
  final String websiteLink;
  final String instagram;
  final String youtube;
  final String facebook;
  final String linkedin;
  final int status;
  final String mobile;

  InfluencerDetails({
    required this.id,
    required this.userId,
    required this.name,
    required this.profession,
    required this.bio,
    required this.image,
    required this.niche,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.websiteLink,
    required this.instagram,
    required this.youtube,
    required this.facebook,
    required this.linkedin,
    required this.status,
    required this.mobile,
  });

  factory InfluencerDetails.fromJson(Map<String, dynamic> json) {
    return InfluencerDetails(
      id: json['id'] ?? 0,
      userId: json['app_user_id'] ?? 0,
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
      niche: json['niche'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      websiteLink: json['website_link'] ?? '',
      instagram: json['instagram'] ?? '',
      youtube: json['youtube'] ?? '',
      facebook: json['facebook'] ?? '',
      linkedin: json['linkedin'] ?? '',
      status: json['status'] is int ? json['status'] : 0,
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "name": name,
      "profession": profession,
      "bio": bio,
      "image": image,
      "niche": niche,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "website_link": websiteLink,
      "instagram": instagram,
      "youtube": youtube,
      "facebook": facebook,
      "linkedin": linkedin,
      "status": status,
      "mobile": mobile,
    };
  }
}
