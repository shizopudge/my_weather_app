import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/models/weather_week_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc()
      : super(WeatherState(
          weather: WeatherModel(),
          lastUpdate: DateTime.now(),
        )) {
    on<WeatherGetWeatherEvent>(_onGetWeather);
    on<WeatherSetUnitsEvent>(_onSetUnits);
    on<WeatherGet24hWeatherEvent>(_onGet24hWeather);
    on<WeatherGetWeekWeatherEvent>(_onGetWeekWeather);
    on<WeatherOnErrorEvent>(_onError);
  }
  final _httpClient = Dio();
  Future _onGetWeather(
      WeatherGetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
    final String? units = prefs.getString('units');
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
          state.copyWith(
            isError: true,
            city: city,
            country: country,
          ),
        );
        throw Exception('Something went wrong');
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isError: true,
          city: city,
          country: country,
        ),
      );
      throw Exception('Something went wrong ($e)');
    }
  }

  _onSetUnits(WeatherSetUnitsEvent event, Emitter<WeatherState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('units', event.units);
  }

  Future _onGet24hWeather(
      WeatherGet24hWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? units = prefs.getString('units');
    final List<WeatherModel> weather24hList = [];
    const int count = 9;
    try {
      final res = await _httpClient.get(
          'https://api.openweathermap.org/data/2.5/forecast?',
          queryParameters: {
            'q': city,
            'units': units,
            'appid': '476834e607173de250e2b4595cc852af',
            'cnt': count,
          });
      for (int i = 0; i < count; i++) {
        weather24hList.add(WeatherModel.fromJson(res.data['list'][i]));
      }
      if (res.statusCode == 200) {
        emit(state.copyWith(
          weather24hList: weather24hList,
          isLoading: false,
          lastUpdate: DateTime.now(),
        ));
      } else if (res.statusCode == 401) {
        emit(state.copyWith(
          isError: true,
        ));
        throw Exception('Invalid API key');
      } else {
        emit(
          state.copyWith(isError: true),
        );
        throw Exception('Something went wrong');
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isError: true,
        ),
      );
      throw Exception('Something went wrong ($e)');
    }
  }

  Future _onGetWeekWeather(
      WeatherGetWeekWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? units = prefs.getString('units');
    final List<WeatherModel> weatherWeekList = [];
    final List<WeatherWeekModel> returnWeatherWeekList = [];
    const int count = 40;
    try {
      final res = await _httpClient.get(
          'https://api.openweathermap.org/data/2.5/forecast?',
          queryParameters: {
            'q': city,
            'units': units,
            'appid': '476834e607173de250e2b4595cc852af',
            'cnt': count,
          });
      for (int i = 0; i < count; i++) {
        weatherWeekList.add(WeatherModel.fromJson(res.data['list'][i]));
      }
      for (int i = 0; i < 4; i++) {
        final List<WeatherModel> computationList = [];
        double sumTemp = 0;
        double sumMinTemp = 0;
        double sumMaxTemp = 0;
        int sumHumidity = 0;
        String weekday = '';
        String dayIcon = '01d';
        String nightIcon = '01n';
        for (WeatherModel weather in weatherWeekList) {
          final DateTime dt =
              DateTime.fromMillisecondsSinceEpoch((weather.dt ?? 0) * 1000);
          final int weatherDt =
              DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
          final int currentDt = DateTime(DateTime.now().year,
                  DateTime.now().month, (DateTime.now().day + 1) + i)
              .millisecondsSinceEpoch;
          if (weatherDt == currentDt) {
            if (dt.hour > 6 && dt.hour < 18) {
              dayIcon = weather.icon ?? '';
            }
            if (dt.hour > 18 || dt.hour < 6) {
              nightIcon = weather.icon ?? '';
            }
            switch (
                DateTime.fromMillisecondsSinceEpoch((weather.dt ?? 0) * 1000)
                    .weekday) {
              case 1:
                weekday = 'Monday';
                break;
              case 2:
                weekday = 'Tuesday';
                break;
              case 3:
                weekday = 'Wednesday';
                break;
              case 4:
                weekday = 'Thursday';
                break;
              case 5:
                weekday = 'Friday';
                break;
              case 6:
                weekday = 'Saturday';
                break;
              case 7:
                weekday = 'Sunday';
                break;
              default:
            }
            computationList.add(weather);
          }
        }
        for (int j = 0; j < computationList.length; j++) {
          sumTemp = sumTemp + double.parse(computationList[j].temp ?? '0');
          sumMinTemp =
              sumMinTemp + double.parse(computationList[j].tempMin ?? '0');
          sumMaxTemp =
              sumMaxTemp + double.parse(computationList[j].tempMax ?? '0');
          sumHumidity =
              sumHumidity + int.parse(computationList[j].humidity ?? '0');
        }
        String avgTemp =
            (sumTemp / computationList.length).roundToDouble().toString();
        String avgMinTemp =
            (sumMinTemp / computationList.length).roundToDouble().toString();
        String avgMaxTemp =
            (sumMaxTemp / computationList.length).roundToDouble().toString();
        String avgHumidity =
            (sumHumidity / computationList.length).round().toString();
        DateTime returnDt = DateTime.fromMillisecondsSinceEpoch(
            (computationList.last.dt ?? 0) * 1000);
        returnWeatherWeekList.add(
          WeatherWeekModel(
            iconDay: dayIcon,
            iconNight: nightIcon,
            avgTemp: avgTemp,
            avgMinTemp: avgMinTemp,
            avgMaxTemp: avgMaxTemp,
            avgHumidity: avgHumidity,
            weekday: weekday,
            dt: returnDt,
          ),
        );
      }
      if (res.statusCode == 200) {
        emit(state.copyWith(
          weatherWeekList: returnWeatherWeekList,
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

  _onError(WeatherOnErrorEvent event, Emitter<WeatherState> emit) {
    emit(state.copyWith(isError: true));
  }
}
