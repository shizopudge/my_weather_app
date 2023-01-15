import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/models/weather_week_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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
    on<WeatherInitGetWeatherEvent>(_onInitGetWeather);
    on<WeatherInitGet24hWeatherEvent>(_onInitGet24hWeather);
    on<WeatherInitGetWeekWeatherEvent>(_onInitGetWeekWeather);
    on<WeatherOnErrorEvent>(_onError);
  }

  final _httpClient = Dio(
    BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 10000,
    ),
  );

  Future _onGetWeather(
      WeatherGetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
    final String? units = prefs.getString('units');
    try {
      final Response res = await _httpClient.get(
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
      throw Exception('$e');
    }
  }

  Future _onGet24hWeather(
      WeatherGet24hWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
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

  Future _onGetWeekWeather(
      WeatherGetWeekWeatherEvent event, Emitter<WeatherState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
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
      if (res.statusCode == 200) {
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
        emit(state.copyWith(
          weatherWeekList: returnWeatherWeekList,
          isLoading: false,
          lastUpdate: DateTime.now(),
        ));
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

  Future _onInitGetWeather(
      WeatherInitGetWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
    final String? units = prefs.getString('units');
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> favoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> favoriteLocations =
        List.generate(favoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: favoriteLocationsMaps[i]['id'],
        city: favoriteLocationsMaps[i]['city'],
        country: favoriteLocationsMaps[i]['country'],
      );
    });
    if (favoriteLocations.isNotEmpty) {
      prefs.setString('city', favoriteLocations.first.city ?? '');
      prefs.setString('country', favoriteLocations.first.country ?? '');
      try {
        final Response res = await _httpClient.get(
            'https://api.openweathermap.org/data/2.5/weather',
            queryParameters: {
              'q': favoriteLocations.first.city,
              'units': units,
              'appid': '476834e607173de250e2b4595cc852af',
            });
        if (res.statusCode == 200) {
          emit(state.copyWith(
            weather: WeatherModel.fromJson(res.data),
            city: favoriteLocations.first.city,
            country: favoriteLocations.first.country,
            units: units,
            isLoading: false,
            lastUpdate: DateTime.now(),
          ));
          await HomeWidget.saveWidgetData<String>(
              '_temp', WeatherModel.fromJson(res.data).temp ?? '');
          await HomeWidget.saveWidgetData<String>('_description',
              '${WeatherModel.fromJson(res.data).weatherMain}/${WeatherModel.fromJson(res.data).weatherDescription}');
          await HomeWidget.saveWidgetData<String>(
              '_city', favoriteLocations.first.city ?? '');
          await HomeWidget.saveWidgetData<String>(
            '_updated',
            DateFormat('dd.MM HH:mm').format(
              DateTime.now(),
            ),
          );
          await HomeWidget.updateWidget(
              name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
        } else {
          emit(
            state.copyWith(
              isError: true,
              city: favoriteLocations.first.city,
              country: favoriteLocations.first.country,
            ),
          );
          throw Exception('Something went wrong');
        }
      } on Exception catch (e) {
        throw Exception('$e');
      }
    } else {
      try {
        final Response res = await _httpClient.get(
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
        throw Exception('$e');
      }
    }
  }

  Future _onInitGet24hWeather(
      WeatherInitGet24hWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
    final String? units = prefs.getString('units');
    final List<WeatherModel> weather24hList = [];
    const int count = 9;
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> favoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> favoriteLocations =
        List.generate(favoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: favoriteLocationsMaps[i]['id'],
        city: favoriteLocationsMaps[i]['city'],
        country: favoriteLocationsMaps[i]['country'],
      );
    });
    if (favoriteLocations.isNotEmpty) {
      try {
        final res = await _httpClient.get(
            'https://api.openweathermap.org/data/2.5/forecast?',
            queryParameters: {
              'q': favoriteLocations.first.city,
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
    } else {
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
  }

  Future _onInitGetWeekWeather(
      WeatherInitGetWeekWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
    final String? units = prefs.getString('units');
    final List<WeatherModel> weatherWeekList = [];
    final List<WeatherWeekModel> returnWeatherWeekList = [];
    const int count = 40;
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> favoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> favoriteLocations =
        List.generate(favoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: favoriteLocationsMaps[i]['id'],
        city: favoriteLocationsMaps[i]['city'],
        country: favoriteLocationsMaps[i]['country'],
      );
    });
    if (favoriteLocations.isNotEmpty) {
      try {
        final res = await _httpClient.get(
            'https://api.openweathermap.org/data/2.5/forecast?',
            queryParameters: {
              'q': favoriteLocations.first.city,
              'units': units,
              'appid': '476834e607173de250e2b4595cc852af',
              'cnt': count,
            });
        if (res.statusCode == 200) {
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
                switch (DateTime.fromMillisecondsSinceEpoch(
                        (weather.dt ?? 0) * 1000)
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
            String avgMinTemp = (sumMinTemp / computationList.length)
                .roundToDouble()
                .toString();
            String avgMaxTemp = (sumMaxTemp / computationList.length)
                .roundToDouble()
                .toString();
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
          emit(state.copyWith(
            weatherWeekList: returnWeatherWeekList,
            isLoading: false,
            lastUpdate: DateTime.now(),
          ));
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
    } else {
      try {
        final res = await _httpClient.get(
            'https://api.openweathermap.org/data/2.5/forecast?',
            queryParameters: {
              'q': city,
              'units': units,
              'appid': '476834e607173de250e2b4595cc852af',
              'cnt': count,
            });
        if (res.statusCode == 200) {
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
                switch (DateTime.fromMillisecondsSinceEpoch(
                        (weather.dt ?? 0) * 1000)
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
            String avgMinTemp = (sumMinTemp / computationList.length)
                .roundToDouble()
                .toString();
            String avgMaxTemp = (sumMaxTemp / computationList.length)
                .roundToDouble()
                .toString();
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
          emit(state.copyWith(
            weatherWeekList: returnWeatherWeekList,
            isLoading: false,
            lastUpdate: DateTime.now(),
          ));
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
  }

  _onSetUnits(WeatherSetUnitsEvent event, Emitter<WeatherState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('units', event.units);
  }

  _onError(WeatherOnErrorEvent event, Emitter<WeatherState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? city = prefs.getString('city');
    final String? country = prefs.getString('country');
    emit(
      state.copyWith(
        isError: true,
        city: city,
        country: country,
      ),
    );
  }
}
