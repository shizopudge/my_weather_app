class LocationModel {
  final int? id;
  final String? city;
  final String? country;

  LocationModel({
    this.id,
    this.city,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'country': country,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] != null ? map['id'] as int : null,
      city: map['city'] != null ? map['city'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
    );
  }
}
