class AdvertisementResponse {
  final bool status;
  final String message;
  final AdvertisementData? data;

  AdvertisementResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AdvertisementResponse.fromJson(Map<String, dynamic> json) {
    return AdvertisementResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AdvertisementData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class AdvertisementData {
  final int? appUserId;
  final String? title;
  final String? sponsorName;
  final String? adType;
  final String? userListingId;
  final String? userListingName;
  final String? adStatus;
  final String? image;
  final String? targetingType;
  final String? location;
  final String? latitude;
  final String? longitude;
  final String? startDate;
  final String? endDate;
  final String? ctaButton;
  final String? ctaLink;
  final String? promotionDays;
  final String? totalPrice;
  final String? mobile;

  // Razorpay fields
  final String? razorpayPaymentId;
  final String? razorpayOrderId;
  final String? razorpaySignature;

  final int? status;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  AdvertisementData({
    this.appUserId,
    this.title,
    this.sponsorName,
    this.adType,
    this.userListingId,
    this.userListingName,
    this.adStatus,
    this.image,
    this.targetingType,
    this.location,
    this.latitude,
    this.longitude,
    this.startDate,
    this.endDate,
    this.ctaButton,
    this.ctaLink,
    this.promotionDays,
    this.totalPrice,
    this.mobile,
    this.razorpayPaymentId,
    this.razorpayOrderId,
    this.razorpaySignature,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory AdvertisementData.fromJson(Map<String, dynamic> json) {
    return AdvertisementData(
      appUserId: json['app_user_id'],
      title: json['title'],
      sponsorName: json['sponsor_name'],
      adType: json['ad_type'],
      userListingId: json['user_listing_id'],
      userListingName: json['user_listing_name'],
      adStatus: json['ad_status'],
      image: json['image'],
      targetingType: json['targeting_type'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      ctaButton: json['cta_button'],
      ctaLink: json['cta_link'],
      promotionDays: json['promotion_days'],
      totalPrice: json['total_price'],
      mobile: json['mobile'],
      razorpayPaymentId: json['razorpay_payment_id'],
      razorpayOrderId: json['razorpay_order_id'],
      razorpaySignature: json['razorpay_signature'],
      status: json['status'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'app_user_id': appUserId,
    'title': title,
    'sponsor_name': sponsorName,
    'ad_type': adType,
    'user_listing_id': userListingId,
    'user_listing_name': userListingName,
    'ad_status': adStatus,
    'image': image,
    'targeting_type': targetingType,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'start_date': startDate,
    'end_date': endDate,
    'cta_button': ctaButton,
    'cta_link': ctaLink,
    'promotion_days': promotionDays,
    'total_price': totalPrice,
    'mobile': mobile,
    'status': status,
    'updated_at': updatedAt,
    'created_at': createdAt,
    'id': id,
  };
}

class AdUserListingResponse {
  bool status;
  String message;
  List<AdUserListing> data;

  AdUserListingResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdUserListingResponse.fromJson(Map<String, dynamic> json) {
    return AdUserListingResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<AdUserListing>.from(
          json['data'].map((x) => AdUserListing.fromJson(x)))
          : [],
    );
  }
}

class AdUserListing {
  int id;
  String name;

  AdUserListing({
    required this.id,
    required this.name,
  });

  factory AdUserListing.fromJson(Map<String, dynamic> json) {
    return AdUserListing(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
