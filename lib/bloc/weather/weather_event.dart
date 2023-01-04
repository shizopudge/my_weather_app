abstract class WeatherEvent {}

class WeatherGetWeatherEvent extends WeatherEvent {
  final String? city;
  final String? country;
  final String? units;

  WeatherGetWeatherEvent({
    this.city,
    this.country,
    this.units,
  });
}

class WeatherSetUnitsEvent extends WeatherEvent {
  final String units;

  WeatherSetUnitsEvent({required this.units});
}
