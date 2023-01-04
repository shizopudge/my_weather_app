class CountryModel {
  final String? countryName;
  final List<dynamic>? cities;
  CountryModel({
    this.countryName,
    this.cities,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      countryName: json['country'],
      cities: json['cities'],
    );
  }
}
