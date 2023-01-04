import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  LocalBloc() : super(LocalState()) {
    on<LocalSetLaunchStateEvent>(_onSetLaunchState);
    on<LocalGetLaunchStateEvent>(_onGetLaunchState);
  }

  _onSetLaunchState(
      LocalSetLaunchStateEvent event, Emitter<LocalState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    await prefs.setString('city', 'Moscow');
    await prefs.setString('country', 'Russia');
    await prefs.setString('units', 'metric');
  }

  _onGetLaunchState(
      LocalGetLaunchStateEvent event, Emitter<LocalState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch');
    emit(
      LocalState(isFirstLaunch: isFirstLaunch ?? true),
    );
  }
}
