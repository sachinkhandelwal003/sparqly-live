class AnalyticsResponse {
  final bool status;
  final AnalyticsData? data;

  AnalyticsResponse({
    required this.status,
    this.data,
  });

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return AnalyticsResponse(
      status: json['status'] ?? false,
      data: json['data'] != null
          ? AnalyticsData.fromJson(json['data'])
          : null,
    );
  }
}

class AnalyticsData {
  final String range;
  final AnalyticsSummary summary;
  final List<DailyView> dailyViews;
  final List<TypeDistribution> typeDistribution;
  final List<TopListing> topListings;

  AnalyticsData({
    required this.range,
    required this.summary,
    required this.dailyViews,
    required this.typeDistribution,
    required this.topListings,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      range: json['range'] ?? '',
      summary: AnalyticsSummary.fromJson(json['summary'] ?? {}),
      dailyViews: (json['daily_views'] as List? ?? [])
          .map((e) => DailyView.fromJson(e))
          .toList(),
      typeDistribution: (json['type_distribution'] as List? ?? [])
          .map((e) => TypeDistribution.fromJson(e))
          .toList(),
      topListings: (json['top_listings'] as List? ?? [])
          .map((e) => TopListing.fromJson(e))
          .toList(),
    );
  }
}

class AnalyticsSummary {
  final int totalViews;

  AnalyticsSummary({required this.totalViews});

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      totalViews: json['total_views'] ?? 0,
    );
  }
}

class DailyView {
  final String date;
  final int views;

  DailyView({
    required this.date,
    required this.views,
  });

  factory DailyView.fromJson(Map<String, dynamic> json) {
    return DailyView(
      date: json['date'] ?? '',
      views: json['views'] ?? 0,
    );
  }
}

class TypeDistribution {
  final String dataType;
  final int views;

  TypeDistribution({
    required this.dataType,
    required this.views,
  });

  factory TypeDistribution.fromJson(Map<String, dynamic> json) {
    return TypeDistribution(
      dataType: json['data_type'] ?? '',
      views: json['views'] ?? 0,
    );
  }
}

class TopListing {
  final int dataId;
  final String dataType;
  final int views;

  TopListing({
    required this.dataId,
    required this.dataType,
    required this.views,
  });

  factory TopListing.fromJson(Map<String, dynamic> json) {
    return TopListing(
      dataId: json['data_id'] ?? 0,
      dataType: json['data_type'] ?? '',
      views: json['views'] ?? 0,
    );
  }
}
