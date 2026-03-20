class SubscriptionPlanActive {
  final bool status;
  final String message;
  final String planName;
  final Access access;

  SubscriptionPlanActive({
    required this.status,
    required this.message,
    required this.planName,
    required this.access,
  });

  factory SubscriptionPlanActive.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanActive(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      planName: json['plan_name'] ?? '',
      access: Access.fromJson(json['access'] ?? {}),
    );
  }
}


class Access {
  final bool chatAccess;
  final bool analyticsAccess;
  final bool advanceAnalytics;
  final bool prioritySearch;
  final bool verifiedBadge;
  final bool prioritySupport;

  final bool businessAdd;
  final bool jobAdd;
  final bool influencerAdd;
  final bool courseAdd;
  final bool offerAdd;

  final int activeListing;

  Access({
    required this.chatAccess,
    required this.analyticsAccess,
    required this.advanceAnalytics,
    required this.prioritySearch,
    required this.verifiedBadge,
    required this.prioritySupport,
    required this.businessAdd,
    required this.jobAdd,
    required this.influencerAdd,
    required this.courseAdd,
    required this.offerAdd,
    required this.activeListing,
  });

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      chatAccess: json['chat_access'] ?? false,
      analyticsAccess: json['analytics_access'] ?? false,
      advanceAnalytics: json['advance_analytics'] ?? false,
      prioritySearch: json['priority_search'] ?? false,
      verifiedBadge: json['verified_badge'] ?? false,
      prioritySupport: json['priority_support'] ?? false,

      businessAdd: json['business_add'] ?? false,
      jobAdd: json['job_add'] ?? false,
      influencerAdd: json['influencer_add'] ?? false,
      courseAdd: json['course_add'] ?? false,
      offerAdd: json['offer_add'] ?? false,

      activeListing: json['active_listing'] ?? 0,
    );
  }
}

