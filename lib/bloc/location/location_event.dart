part of 'location_bloc.dart';

abstract class LocationEvent {}

class LocationGetCititesEvent extends LocationEvent {}

class LocationSearchLocationEvent extends LocationEvent {
  final String query;

  LocationSearchLocationEvent(this.query);
}

class LocationSetCityEvent extends LocationEvent {
  final String countryName;
  final String cityName;

  LocationSetCityEvent(this.countryName, this.cityName);
}
