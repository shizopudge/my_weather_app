part of 'city_bloc.dart';

abstract class CityEvent {}

class CityGetCititesEvent extends CityEvent {}

class CitySearchLocationEvent extends CityEvent {
  final String query;

  CitySearchLocationEvent(this.query);
}

class CitySetCityEvent extends CityEvent {
  final String countryName;
  final String cityName;

  CitySetCityEvent(this.countryName, this.cityName);
}
