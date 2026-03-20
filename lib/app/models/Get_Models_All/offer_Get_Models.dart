class OfferListResponse {
  final bool status;
  final String message;
  final List<OfferData> data;

  OfferListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OfferListResponse.fromJson(Map<String, dynamic> json) {
    return OfferListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OfferData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class OfferData {
  final int id;
  final int appUserId;
  final String title;
  final String description;
  final String? redemptionType;
  final String? couponCode;
  final String? onlineRedemptionInstructions;
  final String? offlineRedemptionInstructions;
  final String location;
  final String latitude;
  final String longitude;
  final String image;
  final String discountType;
  final String originalPrice;
  final String discountValue;
  final String targetAudience;
  final String usageLimit;
  final String offerValidity;
  final String termsConditions;
  final String mobile;
  final int status;

  OfferData({
    required this.id,
    required this.appUserId,
    required this.title,
    required this.description,
    this.redemptionType,
    this.couponCode,
    this.onlineRedemptionInstructions,
    this.offlineRedemptionInstructions,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.discountType,
    required this.originalPrice,
    required this.discountValue,
    required this.targetAudience,
    required this.usageLimit,
    required this.offerValidity,
    required this.termsConditions,
    required this.mobile,
    required this.status,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      id: json['id'] ?? 0,
      appUserId: json['app_user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      redemptionType: json['redemption_type'],
      couponCode: json['coupon_code'],
      onlineRedemptionInstructions: json['online_redemption_instructions'],
      offlineRedemptionInstructions: json['offline_redemption_instructions'],
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      image: json['image'] ?? '',
      discountType: json['discount_type'] ?? '',
      originalPrice: json['original_price'] ?? '',
      discountValue: json['discount_value'] ?? '',
      targetAudience: json['target_audience'] ?? '',
      usageLimit: json['usage_limit'] ?? '',
      offerValidity: json['offer_validity'] ?? '',
      termsConditions: json['terms_conditions'] ?? '',
      mobile: json['mobile'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "app_user_id": appUserId,
      "title": title,
      "description": description,
      "redemption_type": redemptionType,
      "coupon_code": couponCode,
      "online_redemption_instructions": onlineRedemptionInstructions,
      "offline_redemption_instructions": offlineRedemptionInstructions,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "image": image,
      "discount_type": discountType,
      "original_price": originalPrice,
      "discount_value": discountValue,
      "target_audience": targetAudience,
      "usage_limit": usageLimit,
      "offer_validity": offerValidity,
      "terms_conditions": termsConditions,
      "mobile": mobile,
      "status": status,
    };
  }
}
