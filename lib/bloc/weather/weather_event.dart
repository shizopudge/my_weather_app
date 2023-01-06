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

class WeatherGetSeveralWeatherEvent extends WeatherEvent {
  final String? city;
  final String? country;
  final String? units;
  final int? count;

  WeatherGetSeveralWeatherEvent({
    this.city,
    this.country,
    this.units,
    this.count,
  });
}

class WeatherSetUnitsEvent extends WeatherEvent {
  final String units;

  WeatherSetUnitsEvent({required this.units});
}
