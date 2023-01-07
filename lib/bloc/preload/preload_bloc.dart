import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:my_weather_app/constants/images.dart';

part 'preload_event.dart';
part 'preload_state.dart';

class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {
  PreloadBloc() : super(PreloadState()) {
    on<PreloadPrecacheImagesEvent>(_onPrecacheImages);
  }

  _onPrecacheImages(
      PreloadPrecacheImagesEvent event, Emitter<PreloadState> emit) {
    emit(state.copyWith(isLoading: true));
    precacheImage(ConstImages.bg, event.context);
    precacheImage(ConstImages.cloudiness, event.context);
    precacheImage(ConstImages.humidity, event.context);
    precacheImage(ConstImages.pressure, event.context);
    precacheImage(ConstImages.sunrise, event.context);
    precacheImage(ConstImages.sunset, event.context);
    precacheImage(ConstImages.wind, event.context);
    precacheImage(const AssetImage('assets/icons/cloud.png'), event.context);
    precacheImage(const AssetImage('assets/icons/celsius.png'), event.context);
    precacheImage(
        const AssetImage('assets/icons/fahrenheit.png'), event.context);
    emit(state.copyWith(isLoading: false));
  }
}
