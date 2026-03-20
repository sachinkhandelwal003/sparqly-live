import 'dart:convert';

class OfferDetailsResponse {
  final bool status;
  final String message;
  final OfferDetails? data;

  OfferDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory OfferDetailsResponse.fromJson(Map<String, dynamic> json) {
    return OfferDetailsResponse(
      status: json['status'] == true,
      message: json['messsage'] ?? '',
      data: json['data'] != null ? OfferDetails.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "messsage": message,
      "data": data?.toJson(),
    };
  }

  static OfferDetailsResponse fromRawJson(String str) =>
      OfferDetailsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class OfferDetails {
  final int id;
  final int UserId;
  final String title;
  final String description;
  final String redemptionType;
  final String? couponCode;
  final String? onlineRedemptionInstructions;
  final String image;
  final String location;
  final String latitude;
  final String longitude;
  final String? offlineRedemptionInstructions;
  final String discountType;
  final String originalPrice;
  final String discountValue;
  final String targetAudience;
  final String usageLimit;
  final String offerValidity;
  final String termsConditions;
  final int status;
  final String mobile;

  OfferDetails({
    required this.id,
    required this.UserId,
    required this.title,
    required this.description,
    required this.redemptionType,
    this.couponCode,
    this.onlineRedemptionInstructions,
    required this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.offlineRedemptionInstructions,
    required this.discountType,
    required this.originalPrice,
    required this.discountValue,
    required this.targetAudience,
    required this.usageLimit,
    required this.offerValidity,
    required this.termsConditions,
    required this.status,
    required this.mobile,
  });

  factory OfferDetails.fromJson(Map<String, dynamic> json) {
    return OfferDetails(
      id: json['id'] ?? 0,
      UserId: json['app_user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      redemptionType: json['redemption_type'] ?? '',
      couponCode: json['coupon_code'],
      onlineRedemptionInstructions: json['online_redemption_instructions'],
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      offlineRedemptionInstructions: json['offline_redemption_instructions'],
      discountType: json['discount_type'] ?? '',
      originalPrice: json['original_price'] ?? '',
      discountValue: json['discount_value'] ?? '',
      targetAudience: json['target_audience'] ?? '',
      usageLimit: json['usage_limit'] ?? '',
      offerValidity: json['offer_validity'] ?? '',
      termsConditions: json['terms_conditions'] ?? '',
      status: json['status'] ?? 0,
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": UserId,
      "title": title,
      "description": description,
      "redemption_type": redemptionType,
      "coupon_code": couponCode,
      "online_redemption_instructions": onlineRedemptionInstructions,
      "image": image,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "offline_redemption_instructions": offlineRedemptionInstructions,
      "discount_type": discountType,
      "original_price": originalPrice,
      "discount_value": discountValue,
      "target_audience": targetAudience,
      "usage_limit": usageLimit,
      "offer_validity": offerValidity,
      "terms_conditions": termsConditions,
      "status": status,
      "mobile": mobile,
    };
  }
}
