part of 'local_bloc.dart';

@immutable
abstract class LocalEvent {}

class LocalSetLaunchStateEvent extends LocalEvent {}

class LocalGetLaunchStateEvent extends LocalEvent {}

class LocalSetThemeStateEvent extends LocalEvent {
  final String theme;

  LocalSetThemeStateEvent(this.theme);
}
