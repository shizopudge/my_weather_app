import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc()
      : super(WeatherState(
          weather: WeatherModel(),
          lastUpdate: DateTime.now(),
        )) {
    on<WeatherGetWeatherEvent>(_onGetWeather);
    on<WeatherSetUnitsEvent>(_onSetUnits);
  }
  final _httpClient = Dio();
  Future _onGetWeather(
      WeatherGetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('city');
    final country = prefs.getString('country');
    final units = prefs.getString('units');
    try {
      final res = await _httpClient.get(
          'https://api.openweathermap.org/data/2.5/weather',
          queryParameters: {
            'q': city,
            'units': units,
            'appid': '476834e607173de250e2b4595cc852af',
          });
      if (res.statusCode == 200) {
        emit(state.copyWith(
          weather: WeatherModel.fromJson(res.data),
          city: city,
          country: country,
          units: units,
          isLoading: false,
          lastUpdate: DateTime.now(),
        ));
      } else if (res.statusCode == 401) {
        emit(state.copyWith(isError: true));
        throw Exception('Invalid API key');
      } else {
        emit(
          state.copyWith(isError: true),
        );
        throw Exception('Something went wrong');
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(isError: true),
      );
      throw Exception('Something went wrong ($e)');
    }
  }

  _onSetUnits(WeatherSetUnitsEvent event, Emitter<WeatherState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('units', event.units);
  }
}
