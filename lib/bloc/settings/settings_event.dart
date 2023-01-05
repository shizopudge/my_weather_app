part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SettingsInitScreenEvent extends SettingsEvent {}

class SettingsChangeUnitsEvent extends SettingsEvent {
  final int index;
  final String units;

  SettingsChangeUnitsEvent(this.index, this.units);
}
