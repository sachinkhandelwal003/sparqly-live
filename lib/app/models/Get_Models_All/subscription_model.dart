class SubscriptionPlanResponse {
  bool status;
  String message;
  List<SubscriptionPlan> data;

  SubscriptionPlanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<SubscriptionPlan>.from(
          json['data'].map((x) => SubscriptionPlan.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubscriptionPlan {
  int id;
  String name;
  String shortDesc;
  String description;
  String? billingType;
  int monthlyPrice;
  int yearlyPrice;
  String discountType;
  int discountValue;
  String discountValidTill;
  int isPopular;
  int status;
  String createdAt;
  String updatedAt;
  String? razorpayMonthlyPlanId;
  String? razorpayYearlyPlanId;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.description,
    this.billingType,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.discountType,
    required this.discountValue,
    required this.discountValidTill,
    required this.isPopular,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.razorpayMonthlyPlanId,
    this.razorpayYearlyPlanId,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortDesc: json['short_desc'] ?? '',
      description: json['description'] ?? '',
      billingType: json['billing_type'],
      monthlyPrice: json['monthly_price'] ?? 0,
      yearlyPrice: json['yearly_price'] ?? 0,
      discountType: json['discount_type'] ?? '',
      discountValue: json['discount_value'] ?? 0,
      discountValidTill: json['discount_valid_till'] ?? '',
      isPopular: json['is_popular'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      razorpayMonthlyPlanId: json['razorpay_monthly_plan_id'],
      razorpayYearlyPlanId: json['razorpay_yearly_plan_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'short_desc': shortDesc,
    'description': description,
    'billing_type': billingType,
    'monthly_price': monthlyPrice,
    'yearly_price': yearlyPrice,
    'discount_type': discountType,
    'discount_value': discountValue,
    'discount_valid_till': discountValidTill,
    'is_popular': isPopular,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'razorpay_monthly_plan_id': razorpayMonthlyPlanId,
    'razorpay_yearly_plan_id': razorpayYearlyPlanId,
  };
}
