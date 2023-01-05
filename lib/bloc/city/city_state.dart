part of 'city_bloc.dart';

class CityState {
  final List<CityModel> cities;
  final List<CityModel>? searchedCities;
  final String? cityName;
  final String? countryName;
  final bool isLoading;
  final bool isError;

  CityState({
    this.cities = const [],
    this.searchedCities = const [],
    this.cityName,
    this.countryName,
    this.isLoading = false,
    this.isError = false,
  });

  CityState copyWith({
    List<CityModel>? cities,
    List<CityModel>? searchedCities,
    String? cityName,
    String? countryName,
    bool isLoading = false,
    bool isError = false,
  }) {
    return CityState(
      cities: cities ?? this.cities,
      searchedCities: searchedCities ?? this.searchedCities,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      isLoading: isLoading,
      isError: isError,
    );
  }
}
