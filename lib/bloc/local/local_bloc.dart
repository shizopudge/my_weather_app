import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:my_weather_app/constants/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
