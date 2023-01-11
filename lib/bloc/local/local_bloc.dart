import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  _onSetLaunchState(
      LocalSetLaunchStateEvent event, Emitter<LocalState> emit) async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', 'Moscow');
    await prefs.setString('country', 'Russia');
    await prefs.setString('units', 'metric');
    await prefs.setStringList(
      'unitsList',
      [
        'metric',
        'imperial',
      ],
    );
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
        'locations', LocationModel(city: 'Moscow', country: 'Russia').toMap());
    await prefs.setBool('isFirstLaunch', false);
    emit(
      state.copyWith(
        isFirstLaunch: false,
        isLoading: false,
      ),
    );
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
}
