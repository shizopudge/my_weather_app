class GeoModel {
  final String? city;
  final String? country;
  GeoModel({
    this.city,
    this.country,
  });

  factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(
      city: json['features'][0]['properties']['city'],
      country: json['features'][0]['properties']['country'],
    );
  }
  @override
  String toString() => 'GeoModel(city: $city, country: $country)';
}
