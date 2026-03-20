class OfferResponse {
  final bool status;
  final String message;
  final OfferData? data;

  OfferResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? OfferData.fromJson(json['data']) : null,
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

class OfferData {
  final int appUserId;
  final String title;
  final String description;
  final String redemptionType;
  final String location;
  final String latitude;
  final String longitude;
  final String redemptionInstructions;
  final String? image;
  final String discountType;
  final String originalPrice;
  final String discountValue;
  final String targetAudience;
  final String usageLimit;
  final String offerValidity;
  final String termsConditions;
  final String mobile;
  final int status;
  final String updatedAt;
  final String createdAt;
  final int id;

  OfferData({
    required this.appUserId,
    required this.title,
    required this.description,
    required this.redemptionType,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.redemptionInstructions,
    this.image,
    required this.discountType,
    required this.originalPrice,
    required this.discountValue,
    required this.targetAudience,
    required this.usageLimit,
    required this.offerValidity,
    required this.termsConditions,
    required this.mobile,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      appUserId: json['app_user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      redemptionType: json['redemption_type'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      redemptionInstructions: json['redemption_instructions'] ?? '',
      image: json['image'],
      discountType: json['discount_type'] ?? '',
      originalPrice: json['original_price'] ?? '',
      discountValue: json['discount_value'] ?? '',
      targetAudience: json['target_audience'] ?? '',
      usageLimit: json['usage_limit'] ?? '',
      offerValidity: json['offer_validity'] ?? '',
      termsConditions: json['terms_conditions'] ?? '',
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
      'title': title,
      'description': description,
      'redemption_type': redemptionType,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'redemption_instructions': redemptionInstructions,
      'image': image,
      'discount_type': discountType,
      'original_price': originalPrice,
      'discount_value': discountValue,
      'target_audience': targetAudience,
      'usage_limit': usageLimit,
      'offer_validity': offerValidity,
      'terms_conditions': termsConditions,
      'mobile': mobile,
      'status': status,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
