class WeatherModel {
  final String? weatherMain;
  final String? weatherDescription;
  final String? cityName;
  final String? temp;
  final String? feelsLike;
  final String? tempMin;
  final String? tempMax;
  final String? pressure;
  final String? windSpeed;
  final String? clouds;
  final String? icon;
  final String? humidity;
  final int? dt;
  final int? sunrise;
  final int? sunset;

  WeatherModel({
    this.weatherMain,
    this.weatherDescription,
    this.cityName,
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.windSpeed,
    this.clouds,
    this.icon,
    this.humidity,
    this.dt,
    this.sunrise,
    this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      weatherMain: json['weather'][0]['main'],
      weatherDescription: json['weather'][0]['description'],
      cityName: json['name'],
      temp: json['main']['temp'].toString(),
      feelsLike: json['main']['feels_like'].toString(),
      tempMin: json['main']['temp_min'].toString(),
      tempMax: json['main']['temp_max'].toString(),
      pressure: json['main']['pressure'].toString(),
      windSpeed: json['wind']['speed'].toString(),
      clouds: json['clouds']['all'].toString(),
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'].toString(),
      dt: json['dt'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
