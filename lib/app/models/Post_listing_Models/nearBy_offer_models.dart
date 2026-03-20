class NearbyOfferModels {
  final bool success;
  final String message;
  final List<NearbyOfferData> data;

  NearbyOfferModels({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NearbyOfferModels.fromJson(Map<String, dynamic> json) {
    return NearbyOfferModels(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NearbyOfferData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class NearbyOfferData {
  final int id;
  final String title;
  final String description;
  final String image;
  final String location;
  final String latitude;
  final String longitude;
  final String distance;

  NearbyOfferData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory NearbyOfferData.fromJson(Map<String, dynamic> json) {
    return NearbyOfferData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
      distance: json['distance'] ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
    };
  }
}
