part of 'preload_bloc.dart';

class PreloadState {
  final bool isLoading;

  PreloadState({
    this.isLoading = false,
  });

  PreloadState copyWith({
    bool isLoading = false,
  }) {
    return PreloadState(isLoading: isLoading);
  }
}
