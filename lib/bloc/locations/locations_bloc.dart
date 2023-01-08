import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsState()) {
    on<LocationsGetLocationsEvent>(_onGetLocations);
    on<LocationsOnSetLocationEvent>(_onSetLocation);
  }

  _onGetLocations(
      LocationsGetLocationsEvent event, Emitter<LocationsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> locationsMaps =
        await db.query('locations');
    final List<Map<String, dynamic>> favoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> locations = List.generate(locationsMaps.length, (i) {
      return LocationModel(
        id: locationsMaps[i]['id'],
        city: locationsMaps[i]['city'],
        country: locationsMaps[i]['country'],
      );
    });
    List<LocationModel> favoriteLocations =
        List.generate(favoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: favoriteLocationsMaps[i]['id'],
        city: favoriteLocationsMaps[i]['city'],
        country: favoriteLocationsMaps[i]['country'],
      );
    });
    emit(
      state.copyWith(
        isLoading: false,
        locations: locations,
        favoriteLocations: favoriteLocations,
      ),
    );
  }

  _onSetLocation(
      LocationsOnSetLocationEvent event, Emitter<LocationsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> locationsMaps =
        await db.query('locations');
    if (locationsMaps.length >= 5) {
      //ДЕЛО
    } else {
      await db.insert(
        'locations',
        LocationModel(
          city: event.city,
          country: event.country,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
