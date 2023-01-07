part of 'preload_bloc.dart';

@immutable
abstract class PreloadEvent {}

class PreloadPrecacheImagesEvent extends PreloadEvent {
  final BuildContext context;

  PreloadPrecacheImagesEvent(this.context);
}
