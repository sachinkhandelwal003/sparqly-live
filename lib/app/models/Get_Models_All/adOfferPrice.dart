class OfferPrice {
  final String offerType;
  final String targetType;
  final int pricePerDay;

  OfferPrice({
    required this.offerType,
    required this.targetType,
    required this.pricePerDay,
  });

  factory OfferPrice.fromJson(Map<String, dynamic> json) {
    return OfferPrice(
      offerType: json['offer_type'],
      targetType: json['target_type'],
      pricePerDay: json['price_per_day'],
    );
  }
}
