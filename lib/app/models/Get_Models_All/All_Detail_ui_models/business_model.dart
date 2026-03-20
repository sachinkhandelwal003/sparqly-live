class BusinessDetailsResponse {
  final bool status;
  final String message;
  final BusinessDetails? data;

  BusinessDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BusinessDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsResponse(
      status: json['status'] ?? false,
      message: json['messsage'] ?? '',
      data: json['data'] != null ? BusinessDetails.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "messsage": message,
      "data": data?.toJson(),
    };
  }
}

class BusinessDetails {
  final int id;
  final int UserId;
  final String businessCatId;
  final String name;
  final String shortDesc;
  final String image;
  final String description;
  final String location;
  final String latitude;
  final String longitude;
  final String websiteLink;
  final String price;
  final String mobile;
  final int status;

  BusinessDetails({
    required this.id,
    required this.UserId,
    required this.businessCatId,
    required this.name,
    required this.shortDesc,
    required this.image,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.websiteLink,
    required this.price,
    required this.mobile,
    required this.status,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      id: json['id'] ?? 0,
      UserId: json['app_user_id'] ?? 0,
      businessCatId: json['business_cat_id'] ?? '',
      name: json['name'] ?? '',
      shortDesc: json['short_desc'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      websiteLink: json['website_link'] ?? '',
      price: json['price'] ?? '',
      mobile: json['mobile'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": UserId,
      "business_cat_id": businessCatId,
      "name": name,
      "short_desc": shortDesc,
      "image": image,
      "description": description,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "website_link": websiteLink,
      "price": price,
      "mobile": mobile,
      "status": status,
    };
  }
}
