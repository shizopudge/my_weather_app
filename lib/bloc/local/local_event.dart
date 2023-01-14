part of 'local_bloc.dart';

@immutable
abstract class LocalEvent {}

class LocalSetLaunchStateEvent extends LocalEvent {
  final bool isFirstLaunchWithGeo;

  LocalSetLaunchStateEvent(this.isFirstLaunchWithGeo);
}

class LocalGetLaunchStateEvent extends LocalEvent {}

class LocalSetFirstLaunchGeo extends LocalEvent {
  final bool value;

  LocalSetFirstLaunchGeo(this.value);
}

class LocalSetThemeStateEvent extends LocalEvent {
  final String theme;

  LocalSetThemeStateEvent(this.theme);
}
