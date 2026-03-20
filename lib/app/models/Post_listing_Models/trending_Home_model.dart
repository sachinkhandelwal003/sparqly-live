class TrendingResponse {
  final bool success;
  final String message;
  final List<TrendingItem> data;

  TrendingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TrendingResponse.fromJson(Map<String, dynamic> json) {
    return TrendingResponse(
      success: json["success"],
      message: json["message"],
      data: List<TrendingItem>.from(
        json["data"].map((x) => TrendingItem.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class TrendingItem {
  final int id;
  final String name;
  final String shortDesc;
  final String image;
  final String? price;
  final String? category;
  final String? location;
  final String avgRating;
  final int totalReviews;
  final String type;

  TrendingItem({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.image,
    this.price,
    this.category,
    this.location,
    required this.avgRating,
    required this.totalReviews,
    required this.type,
  });

  factory TrendingItem.fromJson(Map<String, dynamic> json) {
    return TrendingItem(
      id: json["id"],
      name: json["name"],
      shortDesc: json["short_desc"],
      image: json["image"],
      price: json["price"],
      category: json["category"],
      location: json["location"],
      avgRating: json["avg_rating"],
      totalReviews: json["total_reviews"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "short_desc": shortDesc,
    "image": image,
    "price": price,
    "category": category,
    "location": location,
    "avg_rating": avgRating,
    "total_reviews": totalReviews,
    "type": type,
  };
}
