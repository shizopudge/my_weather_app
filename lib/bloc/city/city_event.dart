abstract class CititesEvent {}

class CityGetCititesEvent extends CititesEvent {
  final List citites;
  final String countryName;

  CityGetCititesEvent(this.citites, this.countryName);
}

class CitySearchCititesEvent extends CititesEvent {
  final String query;
  final List citites;
  final String countryName;

  CitySearchCititesEvent(this.query, this.citites, this.countryName);
}

class CitySetCityEvent extends CititesEvent {
  final String countryName;
  final String cityName;

  CitySetCityEvent(this.countryName, this.cityName);
}
