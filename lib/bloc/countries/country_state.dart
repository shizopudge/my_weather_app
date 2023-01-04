import 'package:my_weather_app/models/country_model.dart';

class CountryState {
  final List<CountryModel> countries;
  final bool isLoading;
  final bool isError;

  CountryState({
    this.countries = const [],
    this.isLoading = false,
    this.isError = false,
  });

  CountryState copyWith({
    List<CountryModel>? countries,
    bool isLoading = false,
    bool isError = false,
  }) {
    return CountryState(
      countries: countries ?? this.countries,
      isLoading: isLoading,
      isError: isError,
    );
  }
}
