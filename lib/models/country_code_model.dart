class CountryCodeModel {
  final String? countryName;
  final String? countryCode;
  CountryCodeModel({
    this.countryName,
    this.countryCode,
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      countryName: json['name'],
      countryCode: json['code'],
    );
  }
}
