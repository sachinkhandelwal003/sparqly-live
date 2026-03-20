class BusinessListResponse {
  final bool status;
  final String message;
  final List<BusinessData> data;

  BusinessListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BusinessListResponse.fromJson(Map<String, dynamic> json) {
    return BusinessListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BusinessData.fromJson(e))
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

class BusinessData {
  final int id;
  final String businessCategory;
  final String name;
  final String shortDesc;
  final String description;
  final String image;
  final String location;
  final String latitude;
  final String longitude;
  final String? websiteLink;
  final String price;
  final String mobile;
  final int status;

  BusinessData({
    required this.id,
    required this.businessCategory,
    required this.name,
    required this.shortDesc,
    required this.description,
    required this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.websiteLink,
    required this.price,
    required this.mobile,
    required this.status,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) {
    return BusinessData(
      id: json['id'] ?? 0,
      businessCategory: json['business_category'] ?? '',
      name: json['name'] ?? '',
      shortDesc: json['short_desc'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      websiteLink: json['website_link'],
      price: json['price']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_category': businessCategory,
      'name': name,
      'short_desc': shortDesc,
      'description': description,
      'image': image,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'website_link': websiteLink,
      'price': price,
      'mobile': mobile,
      'status': status,
    };
  }
}
