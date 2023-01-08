part of 'locations_bloc.dart';

abstract class LocationsEvent {}

class LocationsGetLocationsEvent extends LocationsEvent {}

class LocationsOnSetLocationEvent extends LocationsEvent {
  final String city;
  final String country;

  LocationsOnSetLocationEvent(this.city, this.country);
}
