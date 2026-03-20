class NearYouResponse {
  final bool success;
  final List<NearYouItem> data;

  NearYouResponse({
    required this.success,
    required this.data,
  });

  factory NearYouResponse.fromJson(Map<String, dynamic> json) {
    return NearYouResponse(
      success: json["success"] ?? false,
      data: json["data"] != null
          ? List<NearYouItem>.from(
        json["data"].map((x) => NearYouItem.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class NearYouItem {
  final int id;
  final String name;
  final String shortDesc;
  final String image;
  final String location;
  final String latitude;
  final String longitude;
  final String distance;
  final String category;
  final String type;

  NearYouItem({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.image,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.category,
    required this.type,
  });

  factory NearYouItem.fromJson(Map<String, dynamic> json) {
    return NearYouItem(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      shortDesc: json["short_desc"] ?? "",
      image: json["image"] ?? "",
      location: json["location"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      distance: json["distance"] ?? "",
      category: json["category"] ?? "Unknown",
      type: json["type"] ?? "Unknown",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "short_desc": shortDesc,
    "image": image,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "distance": distance,
    "category": category,
    "type": type,
  };

  /// Quick helpers
  bool get isJob => type.toLowerCase() == "job";
  bool get isBusiness => type.toLowerCase() == "business";
  bool get isInfluencer => type.toLowerCase() == "influencer";
}
