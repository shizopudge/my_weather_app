part of 'settings_bloc.dart';

class SettingsState {
  final List<bool> selections;

  SettingsState({
    this.selections = const [],
  });

  SettingsState copyWith({
    List<bool>? selections,
  }) {
    return SettingsState(
      selections: selections ?? this.selections,
    );
  }
}
