import 'package:my_weather_app/models/weather_model.dart';

class WeatherState {
  final WeatherModel weather;
  final bool isLoading;
  final bool isError;
  final String city;
  final String country;
  final String units;

  WeatherState({
    required this.weather,
    this.isLoading = false,
    this.isError = false,
    this.city = '',
    this.country = '',
    this.units = '',
  });

  WeatherState copyWith({
    WeatherModel? weather,
    String? city,
    String? country,
    String? units,
    bool isLoading = false,
    bool isError = false,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      city: city ?? this.city,
      country: country ?? this.country,
      units: units ?? this.units,
      isLoading: isLoading,
      isError: isError,
    );
  }
}
