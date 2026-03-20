class BookmarkResponse {
  bool status;
  List<BookmarkItem> data;

  BookmarkResponse({required this.status, required this.data});

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkResponse(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookmarkItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class BookmarkItem {
  int id;
  int userId;
  int bookmarkableId;
  String bookmarkableType;
  String createdAt;
  String updatedAt;
  BookmarkData data;

  BookmarkItem({
    required this.id,
    required this.userId,
    required this.bookmarkableId,
    required this.bookmarkableType,
    required this.createdAt,
    required this.updatedAt,
    required this.data,
  });

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      bookmarkableId: json['bookmarkable_id'] ?? 0,
      bookmarkableType: json['bookmarkable_type'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      data: BookmarkData.fromJson(json['data'] ?? {}),
    );
  }
}

class BookmarkData {
  int id;
  String name;
  String desc;
  String image;
  String category;

  BookmarkData({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.category,
  });

  factory BookmarkData.fromJson(Map<String, dynamic> json) {
    return BookmarkData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      desc: json['desc'] ?? "",
      image: json['image'] ?? "",
      category: json['category'] ?? "",
    );
  }
}
