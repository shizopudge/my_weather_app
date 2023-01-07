import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/models/weather_week_model.dart';

class WeatherState {
  final WeatherModel weather;
  final List<WeatherModel> weather24hList;
  final List<WeatherWeekModel> weatherWeekList;
  final bool isLoading;
  final bool isError;
  final String city;
  final String country;
  final String units;
  final DateTime lastUpdate;

  WeatherState({
    required this.weather,
    this.weather24hList = const [],
    this.weatherWeekList = const [],
    this.isLoading = false,
    this.isError = false,
    this.city = '',
    this.country = '',
    this.units = '',
    required this.lastUpdate,
  });

  WeatherState copyWith({
    WeatherModel? weather,
    List<WeatherModel>? weather24hList,
    List<WeatherWeekModel>? weatherWeekList,
    String? city,
    String? country,
    String? units,
    bool isLoading = false,
    bool isError = false,
    DateTime? lastUpdate,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      weather24hList: weather24hList ?? this.weather24hList,
      weatherWeekList: weatherWeekList ?? this.weatherWeekList,
      city: city ?? this.city,
      country: country ?? this.country,
      units: units ?? this.units,
      isLoading: isLoading,
      isError: isError,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
