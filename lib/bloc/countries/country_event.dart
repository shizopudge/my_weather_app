import 'package:my_weather_app/models/country_model.dart';

abstract class CountryEvent {}

class CountryGetCountriesEvent extends CountryEvent {}

class CountrySearchCountryEvent extends CountryEvent {
  final String query;
  final List<CountryModel> countries;

  CountrySearchCountryEvent(this.query, this.countries);
}
