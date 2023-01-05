class WeatherModel {
  final String? weatherMain;
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final double? windSpeed;
  final int? clouds;
  final String? icon;

  WeatherModel({
    this.weatherMain,
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.windSpeed,
    this.clouds,
    this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      weatherMain: json['weather'][0]['main'],
      temp: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      pressure: json['main']['pressure'],
      windSpeed: json['wind']['speed'],
      clouds: json['clouds']['all'],
      icon: json['weather'][0]['icon'],
    );
  }
}
