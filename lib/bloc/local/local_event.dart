part of 'local_bloc.dart';

@immutable
abstract class LocalEvent {}

class LocalSetLaunchStateEvent extends LocalEvent {}

class LocalGetLaunchStateEvent extends LocalEvent {}
