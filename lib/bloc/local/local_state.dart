part of 'local_bloc.dart';

class LocalState {
  final bool isFirstLaunch;
  final bool isLoading;
  final String theme;
  final bool isFirstLaunchWithGeo;

  LocalState({
    this.isFirstLaunch = false,
    this.isLoading = false,
    this.theme = 'light',
    this.isFirstLaunchWithGeo = false,
  });

  LocalState copyWith({
    bool isFirstLaunch = false,
    bool isLoading = false,
    String theme = 'light',
    bool isFirstLaunchWithGeo = false,
  }) {
    return LocalState(
      isFirstLaunch: isFirstLaunch,
      isLoading: isLoading,
      theme: theme,
      isFirstLaunchWithGeo: isFirstLaunchWithGeo,
    );
  }
}
