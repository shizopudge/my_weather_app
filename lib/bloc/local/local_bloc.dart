import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/models/geo_location_model.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  LocalBloc() : super(LocalState()) {
    on<LocalSetLaunchStateEvent>(_onSetLaunchState);
    on<LocalGetLaunchStateEvent>(_onGetLaunchState);
    on<LocalSetThemeStateEvent>(_onSetThemeState);
    on<LocalSetFirstLaunchGeo>(_onSetFirstLaunchGeoState);
  }
  final _httpClient = Dio(
    BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 25000,
    ),
  );

  _onSetLaunchState(
      LocalSetLaunchStateEvent event, Emitter<LocalState> emit) async {
    if (event.isFirstLaunchWithGeo) {
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
        emit(
          state.copyWith(
            isLoading: true,
          ),
        );
        final prefs = await SharedPreferences.getInstance();
        final currentPosition = await Geolocator.getCurrentPosition();
        final res = await _httpClient.get(
            'https://api.geoapify.com/v1/geocode/reverse?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&apiKey=0de2b91f45964cea8ab3ab92d27939b2');
        if (res.statusCode == 200) {
          final geo = GeoModel.fromJson(res.data);
          if (geo.city != null && geo.country != null) {
            await prefs.setString('city', geo.city ?? '');
            await prefs.setString('country', geo.country ?? '');
            await prefs.setString('units', 'metric');
            final db = await openDatabase(
              join(await getDatabasesPath(), 'locations.db'),
              onCreate: (db, version) {
                db.execute(
                  'CREATE TABLE locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)',
                );
                db.execute(
                    'create table favorite_locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)');
              },
              version: 1,
            );
            await db.insert(
                'locations',
                LocationModel(city: geo.city ?? '', country: geo.country ?? '')
                    .toMap());
            await prefs.setBool('isFirstLaunch', false);
          } else {
            await prefs.setString('city', 'Error');
            await prefs.setString('country', 'Error');
            await prefs.setString('units', 'metric');
            await openDatabase(
              join(await getDatabasesPath(), 'locations.db'),
              onCreate: (db, version) {
                db.execute(
                  'CREATE TABLE locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)',
                );
                db.execute(
                    'create table favorite_locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)');
              },
              version: 1,
            );
            await prefs.setBool('isFirstLaunch', false);
          }
          emit(
            state.copyWith(
              isFirstLaunch: false,
              isLoading: false,
            ),
          );
        }
      }
    } else {
      emit(state.copyWith(isLoading: true));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('city', 'Moscow');
      await prefs.setString('country', 'Russia');
      await prefs.setString('units', 'metric');
      final db = await openDatabase(
        join(await getDatabasesPath(), 'locations.db'),
        onCreate: (db, version) {
          db.execute(
            'CREATE TABLE locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)',
          );
          db.execute(
              'create table favorite_locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)');
        },
        version: 1,
      );
      await db.insert('locations',
          LocationModel(city: 'Moscow', country: 'Russia').toMap());
      await prefs.setBool('isFirstLaunch', false);
      emit(
        state.copyWith(
          isFirstLaunch: false,
          isLoading: false,
        ),
      );
    }
  }

  _onGetLaunchState(
      LocalGetLaunchStateEvent event, Emitter<LocalState> emit) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch');
    final theme = prefs.getString('theme') ?? 'light';
    if (isFirstLaunch ?? true) {
      prefs.setString('theme', 'light');
      emit(
        state.copyWith(
          isFirstLaunch: true,
          theme: theme,
          isLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFirstLaunch: false,
          theme: theme,
          isLoading: false,
        ),
      );
    }
  }

  _onSetThemeState(
      LocalSetThemeStateEvent event, Emitter<LocalState> emit) async {
    emit(
      state.copyWith(isLoading: true),
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'theme',
      event.theme,
    );
    emit(
      state.copyWith(
        isFirstLaunch: false,
        isLoading: false,
        theme: event.theme,
      ),
    );
  }

  _onSetFirstLaunchGeoState(
      LocalSetFirstLaunchGeo event, Emitter<LocalState> emit) async {
    emit(
      state.copyWith(
        isFirstLaunchWithGeo: event.value,
        isFirstLaunch: true,
      ),
    );
  }
}
