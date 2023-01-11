import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_weather_app/models/city_model.dart';
import 'package:my_weather_app/models/country_model.dart';
import 'package:stream_transform/stream_transform.dart';

part 'location_event.dart';
part 'location_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<LocationGetCititesEvent>(_onGetCitites);
    on<LocationSearchLocationEvent>(
      _onSearchLocation,
      transformer: debounceDroppable(
        const Duration(milliseconds: 300),
      ),
    );
    on<LocationSetCityEvent>(_onSetCity);
  }

  final _httpClient = Dio();
  Future _onGetCitites(
      LocationGetCititesEvent event, Emitter<LocationState> emit) async {
    emit(LocationState(isLoading: true));
    final res =
        await _httpClient.get('https://countriesnow.space/api/v0.1/countries');
    if (res.statusCode == 200) {
      final countries = (res.data['data'] as List)
          .map((json) => CountryModel.fromJson(json))
          .toList();
      List<CityModel> cities = [];
      for (var country in countries) {
        for (var city in country.cities ?? []) {
          cities.add(
            CityModel(
              cityName: city,
              countryName: country.countryName,
            ),
          );
        }
      }
      emit(state.copyWith(
        cities: cities,
        isLoading: false,
      ));
    } else if (res.statusCode == 401) {
      emit(state.copyWith(isError: true));
      throw Exception('Invalid API key');
    } else {
      emit(state.copyWith(isError: true));
      throw Exception('Something went wrong');
    }
  }

  Future _onSearchLocation(
      LocationSearchLocationEvent event, Emitter<LocationState> emit) async {
    List<CityModel> cities = state.cities;
    List<CityModel> returnCitites = [];
    emit(state.copyWith(
      cities: cities,
      isLoading: false,
    ));
    if (event.query.isEmpty) {
      returnCitites.clear();
      emit(
        state.copyWith(searchedCities: returnCitites),
      );
    }
    if (event.query.isNotEmpty) {
      emit(state.copyWith(
        isLoading: true,
      ));
      for (var city in cities) {
        if (city.countryName!
                .toLowerCase()
                .contains(event.query.toLowerCase().trim()) ||
            city.cityName!
                .toLowerCase()
                .contains(event.query.toLowerCase().trim())) {
          returnCitites.add(city);
        }
      }
      emit(state.copyWith(
        searchedCities: returnCitites,
        isLoading: false,
      ));
    }
  }

  _onSetCity(LocationSetCityEvent event, Emitter<LocationState> emit) async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('city', event.cityName);
    prefs.setString('country', event.countryName);
    emit(
      state.copyWith(
        isLoading: false,
        cityName: event.cityName,
        countryName: event.countryName,
      ),
    );
  }
}
