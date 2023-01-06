import 'package:my_weather_app/models/weather_model.dart';

class WeatherState {
  final WeatherModel weather;
  final List<WeatherModel> weatherList;
  final bool isLoading;
  final bool isError;
  final String city;
  final String country;
  final String units;
  final DateTime lastUpdate;

  WeatherState({
    required this.weather,
    this.weatherList = const [],
    this.isLoading = false,
    this.isError = false,
    this.city = '',
    this.country = '',
    this.units = '',
    required this.lastUpdate,
  });

  WeatherState copyWith({
    WeatherModel? weather,
    List<WeatherModel>? weatherList,
    String? city,
    String? country,
    String? units,
    bool isLoading = false,
    bool isError = false,
    DateTime? lastUpdate,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      weatherList: weatherList ?? this.weatherList,
      city: city ?? this.city,
      country: country ?? this.country,
      units: units ?? this.units,
      isLoading: isLoading,
      isError: isError,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
