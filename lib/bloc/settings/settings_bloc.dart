import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<SettingsChangeUnitsEvent>(_onChangeUnits);
    on<SettingsInitScreenEvent>(_onInit);
  }

  _onInit(SettingsInitScreenEvent event, Emitter<SettingsState> emit) async {
    final List<bool> selections = List.generate(2, (_) => false);
    final prefs = await SharedPreferences.getInstance();
    final units = prefs.getString('units') ?? 'metric';
    if (units == 'metric') {
      selections[0] = true;
    } else if (units == 'imperial') {
      selections[1] = true;
    }
    emit(
      state.copyWith(
        selections: selections,
      ),
    );
  }

  _onChangeUnits(
      SettingsChangeUnitsEvent event, Emitter<SettingsState> emit) async {
    List<bool> selections = List.generate(2, (_) => false);
    selections[event.index] = !selections[event.index];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('units', event.units);
    emit(state.copyWith(selections: selections));
  }
}
