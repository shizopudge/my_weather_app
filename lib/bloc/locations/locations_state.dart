part of 'locations_bloc.dart';

class LocationsState {
  final bool isLoading;
  final List<LocationModel>? favoriteLocations;
  final List<LocationModel>? locations;

  LocationsState({
    this.isLoading = false,
    this.favoriteLocations = const [],
    this.locations = const [],
  });

  LocationsState copyWith({
    bool isLoading = false,
    List<LocationModel>? favoriteLocations,
    List<LocationModel>? locations,
  }) {
    return LocationsState(
      isLoading: isLoading,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
      locations: locations ?? this.locations,
    );
  }
}
