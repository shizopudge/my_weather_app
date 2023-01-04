import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_event.dart';
import 'package:my_weather_app/bloc/city/city_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityBloc extends Bloc<CititesEvent, CityState> {
  CityBloc()
      : super(
          CityState(
            cities: [],
          ),
        ) {
    on<CityGetCititesEvent>(_onGetCitites);
    on<CitySearchCititesEvent>(_onSearchCity);
    on<CitySetCityEvent>(_onSetCity);
  }

  _onGetCitites(CityGetCititesEvent event, Emitter<CityState> emit) {
    emit(
      CityState(cities: event.citites, countryName: event.countryName),
    );
  }

  _onSearchCity(CitySearchCititesEvent event, Emitter<CityState> emit) {
    if (event.query.isEmpty) {
      return;
    }
    if (event.query.length >= 2) {
      List returnCities = [];
      for (var element in event.citites) {
        if (element.toLowerCase().contains(event.query.toLowerCase().trim())) {
          returnCities.add(element);
        }
      }
      emit(CityState(
        cities: returnCities,
        countryName: event.countryName,
      ));
    }
  }

  _onSetCity(CitySetCityEvent event, Emitter<CityState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', event.cityName);
    await prefs.setString('country', event.countryName);
  }
}
