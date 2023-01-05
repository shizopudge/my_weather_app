part of 'local_bloc.dart';

class LocalState {
  final bool isFirstLaunch;
  final bool isLoading;
  final String theme;

  LocalState({
    this.isFirstLaunch = false,
    this.isLoading = false,
    this.theme = 'light',
  });

  LocalState copyWith({
    bool isFirstLaunch = false,
    bool isLoading = false,
    String theme = 'light',
  }) {
    return LocalState(
      isFirstLaunch: isFirstLaunch,
      isLoading: isLoading,
      theme: theme,
    );
  }
}
