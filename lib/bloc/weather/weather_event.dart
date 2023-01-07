abstract class WeatherEvent {}

class WeatherGetWeatherEvent extends WeatherEvent {}

class WeatherGet24hWeatherEvent extends WeatherEvent {}

class WeatherGetWeekWeatherEvent extends WeatherEvent {}

class WeatherSetUnitsEvent extends WeatherEvent {
  final String units;

  WeatherSetUnitsEvent({required this.units});
}

class WeatherOnErrorEvent extends WeatherEvent {}
