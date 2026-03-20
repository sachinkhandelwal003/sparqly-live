class BusinessListingModel {
  final bool status;
  final String message;
  final Business? data;

  BusinessListingModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory BusinessListingModel.fromJson(Map<String, dynamic> json) {
    return BusinessListingModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      message: json['message'] ?? '',
      data: json['data'] != null ? Business.fromJson(json['data']) : null,
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

class Business {
  final String businessCatId;
  final String name;
  final String shortDesc;
  final String description;
  final String? image;
  final String location;
  final String latitude;
  final String longitude;
  final String websiteLink;
  final String price;
  final String mobile;
  final int status;
  final String updatedAt;
  final String createdAt;
  final int id;

  Business({
    required this.businessCatId,
    required this.name,
    required this.shortDesc,
    required this.description,
    this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.websiteLink,
    required this.price,
    required this.mobile,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessCatId: json['business_cat_id']?.toString() ?? '',
      name: json['name'] ?? '',
      shortDesc: json['short_desc'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      location: json['location'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      websiteLink: json['website_link'] ?? '',
      price: json['price']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_cat_id': businessCatId,
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
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
