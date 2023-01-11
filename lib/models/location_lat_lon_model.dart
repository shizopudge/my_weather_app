class LocationLatLonModel {
  final String? lat;
  final String? lon;
  final String? country;
  final String? city;
  LocationLatLonModel({
    this.lat,
    this.lon,
    this.country,
    this.city,
  });

  factory LocationLatLonModel.fromJson(Map<String, dynamic> json) {
    return LocationLatLonModel(
      lat: json['lat'].toString(),
      lon: json['lon'].toString(),
      country: json['country'],
      city: json['name'],
    );
  }
  @override
  String toString() =>
      'LocationLatLonModel(lat: $lat, lon: $lon, country: $country, city: $city)';
}
