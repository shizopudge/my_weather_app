import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/countries/country_event.dart';
import 'package:my_weather_app/bloc/countries/country_state.dart';
import 'package:my_weather_app/models/country_model.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryState()) {
    on<CountryGetCountriesEvent>(_onGetCountries);
    on<CountrySearchCountryEvent>(
      _onSearchCountry,
      transformer: debounceDroppable(
        const Duration(milliseconds: 300),
      ),
    );
  }

  final _httpClient = Dio();
  Future _onGetCountries(
      CountryGetCountriesEvent event, Emitter<CountryState> emit) async {
    emit(CountryState(isLoading: true));
    final res =
        await _httpClient.get('https://countriesnow.space/api/v0.1/countries');
    if (res.statusCode == 200) {
      emit(state.copyWith(
        countries: (res.data['data'] as List)
            .map((json) => CountryModel.fromJson(json))
            .toList(),
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

  Future _onSearchCountry(
      CountrySearchCountryEvent event, Emitter<CountryState> emit) async {
    if (event.query.isEmpty) {
      return;
    }
    if (event.query.length >= 3) {
      emit(CountryState(isLoading: true));
      final res = await _httpClient
          .get('https://countriesnow.space/api/v0.1/countries');
      if (res.statusCode == 200) {
        List<CountryModel> returnCountries = [];
        List<CountryModel> countries = (res.data['data'] as List)
            .map((json) => CountryModel.fromJson(json))
            .toList();
        for (var element in countries) {
          if (element.countryName!
              .toLowerCase()
              .contains(event.query.toLowerCase().trim())) {
            returnCountries.add(element);
          }
        }
        emit(
          CountryState(
            countries: returnCountries,
            isLoading: false,
          ),
        );
      } else if (res.statusCode == 401) {
        emit(state.copyWith(isError: true));
        throw Exception('Invalid API key');
      } else {
        emit(state.copyWith(isError: true));
        throw Exception('Something went wrong');
      }
    }
  }
}
