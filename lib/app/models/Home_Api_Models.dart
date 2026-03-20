class HeroSectionResponse {
  final bool status;
  final String message;
  final HeroData data;

  HeroSectionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HeroSectionResponse.fromJson(Map<String, dynamic> json) {
    return HeroSectionResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: HeroData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class HeroData {
  final List<HeroSection> heroSection;
  final List<AdSection> ads;

  HeroData({
    required this.heroSection,
    required this.ads,
  });

  factory HeroData.fromJson(Map<String, dynamic> json) {
    return HeroData(
      heroSection: (json['hero_section'] as List<dynamic>? ?? [])
          .map((item) => HeroSection.fromJson(item))
          .toList(),
      ads: (json['ads'] as List<dynamic>? ?? [])
          .map((item) => AdSection.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hero_section': heroSection.map((item) => item.toJson()).toList(),
      'ads': ads.map((item) => item.toJson()).toList(),
    };
  }
}

class HeroSection {
  final int id;
  final String heading;
  final String subHeading;
  final String image;
  final String btnName;
  final String btnUrl;
  final String status;

  HeroSection({
    required this.id,
    required this.heading,
    required this.subHeading,
    required this.image,
    required this.btnName,
    required this.btnUrl,
    required this.status,
  });

  factory HeroSection.fromJson(Map<String, dynamic> json) {
    return HeroSection(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      heading: json['heading'] ?? '',
      subHeading: json['sub_heading'] ?? '',
      image: json['image'] ?? '',
      btnName: json['btn_name'] ?? '',
      btnUrl: json['btn_url'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heading': heading,
      'sub_heading': subHeading,
      'image': image,
      'btn_name': btnName,
      'btn_url': btnUrl,
      'status': status,
    };
  }
}

class AdSection {
  final int id;
  final String heading;
  final String? subHeading;
  final String image;
  final String? btnName;
  final String? btnUrl;
  final String status;

  AdSection({
    required this.id,
    required this.heading,
    this.subHeading,
    required this.image,
    this.btnName,
    this.btnUrl,
    required this.status,
  });

  factory AdSection.fromJson(Map<String, dynamic> json) {
    return AdSection(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      heading: json['heading'] ?? '',
      subHeading: json['sub_heading'],
      image: json['image'] ?? '',
      btnName: json['btn_name'],
      btnUrl: json['btn_url'],
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'heading': heading,
      'sub_heading': subHeading,
      'image': image,
      'btn_name': btnName,
      'btn_url': btnUrl,
      'status': status,
    };
  }
}


class BannerItem {
  final int id;
  final String heading;
  final String? subHeading;
  final String image;
  final String? btnName;
  final String? btnUrl;
  final String status;
  final bool isHero;

  BannerItem({
    required this.id,
    required this.heading,
    this.subHeading,
    required this.image,
    this.btnName,
    this.btnUrl,
    required this.status,
    required this.isHero,
  });

  factory BannerItem.fromHero(HeroSection h) => BannerItem(
    id: h.id,
    heading: h.heading,
    subHeading: h.subHeading.isEmpty ? null : h.subHeading,
    image: h.image,
    btnName: h.btnName.isNotEmpty ? h.btnName : null,
    btnUrl: h.btnUrl.isNotEmpty ? h.btnUrl : null,
    status: h.status,
    isHero: true,
  );

  factory BannerItem.fromAd(AdSection a) => BannerItem(
    id: a.id,
    heading: a.heading,
    subHeading: a.subHeading,
    image: a.image,
    btnName: a.btnName,
    btnUrl: a.btnUrl,
    status: a.status,
    isHero: false,
  );
}
