import 'package:my_weather_app/models/location_model.dart';

class SqfliteState {
  final bool isLoading;
  final List<LocationModel>? favoriteLocations;
  final List<LocationModel>? locations;

  SqfliteState({
    this.isLoading = false,
    this.favoriteLocations = const [],
    this.locations = const [],
  });

  SqfliteState copyWith({
    bool isLoading = false,
    List<LocationModel>? favoriteLocations,
    List<LocationModel>? locations,
  }) {
    return SqfliteState(
      isLoading: isLoading,
      favoriteLocations: favoriteLocations ?? this.favoriteLocations,
      locations: locations ?? this.locations,
    );
  }
}
