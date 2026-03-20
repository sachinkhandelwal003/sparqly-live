class Category {
  final int id;
  final String name;
  final String catIcon;
  final String image;
  final String status;

  Category({
    required this.id,
    required this.name,
    required this.catIcon,
    required this.image,
    required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      catIcon: json['cat_icon'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CategoryResponse {
  final bool status;
  final String message;
  final List<Category> categories;

  CategoryResponse({
    required this.status,
    required this.message,
    required this.categories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      categories: json['categories'] != null
          ? List<Category>.from(
          (json['categories'] as List).map((x) => Category.fromJson(x)))
          : [],
    );
  }
}


class CategoryDropdown {
  final int id;
  final String name;
  final int status;

  CategoryDropdown({required this.id, required this.name, required this.status});

  factory CategoryDropdown.fromJson(Map<String, dynamic> json) {
    return CategoryDropdown(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as int,
    );
  }
}
