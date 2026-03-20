class ProfileUserListingModel {
  bool success;
  List<ProfileListingItem> data;

  ProfileUserListingModel({
    required this.success,
    required this.data,
  });

  factory ProfileUserListingModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserListingModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((x) => ProfileListingItem.fromJson(x))
          .toList() ??
          [],
    );
  }
}

class ProfileListingItem {
  int id;
  String name;
  String shortDesc;
  String? image;
  String category;
  String type;

  ProfileListingItem({
   required this.id,
    required this.name,
    required this.shortDesc,
    required this.image,
    required this.category,
    required this.type,
  });

  factory ProfileListingItem.fromJson(Map<String, dynamic> json) {
    return ProfileListingItem(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      shortDesc: json['short_desc']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'short_desc': shortDesc,
    'image': image,
    'category': category,
    'type': type,
  };
}
