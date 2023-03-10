part of 'location_bloc.dart';

class LocationState {
  final List<CityModel> cities;
  final List<CityModel>? searchedCities;
  final String? cityName;
  final String? countryName;
  final bool isGeoDetermined;
  final bool isLoading;
  final bool isError;

  LocationState({
    this.cities = const [],
    this.searchedCities = const [],
    this.cityName,
    this.countryName,
    this.isGeoDetermined = false,
    this.isLoading = false,
    this.isError = false,
  });

  LocationState copyWith({
    List<CityModel>? cities,
    List<CityModel>? searchedCities,
    String? cityName,
    String? countryName,
    bool isGeoDetermined = false,
    bool isLoading = false,
    bool isError = false,
  }) {
    return LocationState(
      cities: cities ?? this.cities,
      searchedCities: searchedCities ?? this.searchedCities,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      isGeoDetermined: isGeoDetermined,
      isLoading: isLoading,
      isError: isError,
    );
  }
}
