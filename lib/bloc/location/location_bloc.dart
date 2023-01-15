import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/models/geo_location_model.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_weather_app/models/city_model.dart';
import 'package:my_weather_app/models/country_model.dart';
import 'package:sqflite/sqflite.dart';
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
    on<LocationGetCurrentLocationEvent>(_onGetCurrentLocation);
  }

  final _httpClient = Dio(
    BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 10000,
    ),
  );

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

  _onGetCurrentLocation(LocationGetCurrentLocationEvent event,
      Emitter<LocationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine ||
          permission == LocationPermission.deniedForever) {
        return;
      }
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      emit(state.copyWith(isLoading: true));
      final currentPosition = await Geolocator.getCurrentPosition();
      final res = await _httpClient.get(
          'https://api.geoapify.com/v1/geocode/reverse?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&apiKey=0de2b91f45964cea8ab3ab92d27939b2');
      if (res.statusCode == 200) {
        final geo = GeoModel.fromJson(res.data);
        if (geo.city != null && geo.country != null) {
          prefs.setString('city', geo.city ?? '');
          prefs.setString('country', geo.country ?? '');
          bool isOkToInsert = true;
          final db = await openDatabase(
            join(await getDatabasesPath(), 'locations.db'),
          );
          final List<Map<String, dynamic>> locationsMaps =
              await db.query('locations');
          final List<Map<String, dynamic>> favoriteLocationsMaps =
              await db.query('favorite_locations');
          List<LocationModel> locations =
              List.generate(locationsMaps.length, (i) {
            return LocationModel(
              id: locationsMaps[i]['id'],
              city: locationsMaps[i]['city'],
              country: locationsMaps[i]['country'],
            );
          });
          List<LocationModel> favoriteLocations =
              List.generate(favoriteLocationsMaps.length, (i) {
            return LocationModel(
              id: favoriteLocationsMaps[i]['id'],
              city: favoriteLocationsMaps[i]['city'],
              country: favoriteLocationsMaps[i]['country'],
            );
          });
          if (locations.length == 5) {
            for (var location in locations) {
              if (location.city == geo.city &&
                  location.country == geo.country) {
                isOkToInsert = false;
              }
            }
            for (var location in favoriteLocations) {
              if (location.city == geo.city &&
                  location.country == geo.country) {
                isOkToInsert = false;
              }
            }
            if (isOkToInsert) {
              await db.delete(
                'locations',
                where: 'id = ?',
                whereArgs: [
                  locations.first.id,
                ],
              );
              await db.insert(
                'locations',
                LocationModel(
                  city: geo.city,
                  country: geo.country,
                ).toMap(),
                conflictAlgorithm: ConflictAlgorithm.ignore,
              );
            }
            emit(
              state.copyWith(
                isLoading: false,
                isGeoDetermined: true,
                cityName: geo.city ?? '',
                countryName: geo.country ?? '',
              ),
            );
          } else {
            for (var location in locations) {
              if (location.city == geo.city &&
                  location.country == geo.country) {
                isOkToInsert = false;
              }
            }
            for (var location in favoriteLocations) {
              if (location.city == geo.city &&
                  location.country == geo.country) {
                isOkToInsert = false;
              }
            }
            if (isOkToInsert) {
              await db.insert(
                'locations',
                LocationModel(
                  city: geo.city,
                  country: geo.country,
                ).toMap(),
                conflictAlgorithm: ConflictAlgorithm.ignore,
              );
            }
            emit(
              state.copyWith(
                isLoading: false,
                isGeoDetermined: true,
                cityName: geo.city ?? '',
                countryName: geo.country ?? '',
              ),
            );
          }
        } else {
          prefs.setString('city', 'Error');
          prefs.setString('country', 'Error');
          emit(
            state.copyWith(
              isLoading: false,
              isError: true,
              cityName: 'Error',
              countryName: 'Error',
            ),
          );
        }
      }
    } else {
      prefs.setString('city', 'Error');
      prefs.setString('country', 'Error');
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          cityName: 'Error',
          countryName: 'Error',
        ),
      );
    }
  }
}
