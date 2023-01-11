import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_event.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_state.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteBloc extends Bloc<SqfliteEvent, SqfliteState> {
  SqfliteBloc() : super(SqfliteState()) {
    on<SqfliteGetLocationsEvent>(_onGetLocations);
    on<SqfliteOnSetLocationEvent>(_onSetLocation);
    on<SqfliteAddLocationToFavoriteEvent>(_onAddLocationToFavorite);
    on<SqfliteDeleteLocationEvent>(_onDeleteLocation);
  }

  _onGetLocations(
      SqfliteGetLocationsEvent event, Emitter<SqfliteState> emit) async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch');
    if (isFirstLaunch ?? true) {
      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    } else {
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
  }

  _onSetLocation(
      SqfliteOnSetLocationEvent event, Emitter<SqfliteState> emit) async {
    emit(state.copyWith(isLoading: true));
    bool isOkToInsert = true;
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
    if (locations.length == 5) {
      for (var location in locations) {
        if (location.city == event.city && location.country == event.country) {
          isOkToInsert = false;
        }
      }
      for (var location in favoriteLocations) {
        if (location.city == event.city && location.country == event.country) {
          isOkToInsert = false;
        }
      }
      if (isOkToInsert) {
        await db.delete(
          'locations',
          where: 'id = ?',
          whereArgs: [
            locations.first.id,
          ],
        );
        await db.insert(
          'locations',
          LocationModel(
            city: event.city,
            country: event.country,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      final List<Map<String, dynamic>> updatedLocationsMaps =
          await db.query('locations');
      final List<Map<String, dynamic>> updatedFavoriteLocationsMaps =
          await db.query('favorite_locations');
      List<LocationModel> updatedLocations =
          List.generate(updatedLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedLocationsMaps[i]['id'],
          city: updatedLocationsMaps[i]['city'],
          country: updatedLocationsMaps[i]['country'],
        );
      });
      List<LocationModel> updatedFavoriteLocations =
          List.generate(updatedFavoriteLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedFavoriteLocationsMaps[i]['id'],
          city: updatedFavoriteLocationsMaps[i]['city'],
          country: updatedFavoriteLocationsMaps[i]['country'],
        );
      });
      emit(
        state.copyWith(
          isLoading: false,
          favoriteLocations: updatedFavoriteLocations,
          locations: updatedLocations,
        ),
      );
    } else {
      for (var location in locations) {
        if (location.city == event.city && location.country == event.country) {
          isOkToInsert = false;
        }
      }
      for (var location in favoriteLocations) {
        if (location.city == event.city && location.country == event.country) {
          isOkToInsert = false;
        }
      }
      if (isOkToInsert) {
        await db.insert(
          'locations',
          LocationModel(
            city: event.city,
            country: event.country,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      final List<Map<String, dynamic>> updatedLocationsMaps =
          await db.query('locations');
      final List<Map<String, dynamic>> updatedFavoriteLocationsMaps =
          await db.query('favorite_locations');
      List<LocationModel> updatedLocations =
          List.generate(updatedLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedLocationsMaps[i]['id'],
          city: updatedLocationsMaps[i]['city'],
          country: updatedLocationsMaps[i]['country'],
        );
      });
      List<LocationModel> updatedFavoriteLocations =
          List.generate(updatedFavoriteLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedFavoriteLocationsMaps[i]['id'],
          city: updatedFavoriteLocationsMaps[i]['city'],
          country: updatedFavoriteLocationsMaps[i]['country'],
        );
      });
      emit(
        state.copyWith(
          isLoading: false,
          favoriteLocations: updatedFavoriteLocations,
          locations: updatedLocations,
        ),
      );
    }
  }

  _onAddLocationToFavorite(SqfliteAddLocationToFavoriteEvent event,
      Emitter<SqfliteState> emit) async {
    emit(state.copyWith(isLoading: true));
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    final List<Map<String, dynamic>> favoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> locations =
        List.generate(favoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: favoriteLocationsMaps[i]['id'],
        city: favoriteLocationsMaps[i]['city'],
        country: favoriteLocationsMaps[i]['country'],
      );
    });
    final prefs = await SharedPreferences.getInstance();
    if (favoriteLocationsMaps.isNotEmpty) {
      await db.delete(
        'favorite_locations',
        where: 'id = ?',
        whereArgs: [
          locations.first.id,
        ],
      );
      await db.insert(
        'favorite_locations',
        LocationModel(
          city: event.city,
          country: event.country,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      await db.delete(
        'locations',
        where: 'id = ?',
        whereArgs: [
          event.id,
        ],
      );
      await db.insert(
        'locations',
        LocationModel(
          city: locations.first.city,
          country: locations.first.country,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      final List<Map<String, dynamic>> updatedLocationsMaps =
          await db.query('locations');
      final List<Map<String, dynamic>> updatedFavoriteLocationsMaps =
          await db.query('favorite_locations');
      List<LocationModel> updatedLocations =
          List.generate(updatedLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedLocationsMaps[i]['id'],
          city: updatedLocationsMaps[i]['city'],
          country: updatedLocationsMaps[i]['country'],
        );
      });
      List<LocationModel> updatedFavoriteLocations =
          List.generate(updatedFavoriteLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedFavoriteLocationsMaps[i]['id'],
          city: updatedFavoriteLocationsMaps[i]['city'],
          country: updatedFavoriteLocationsMaps[i]['country'],
        );
      });
      prefs.setString('city', updatedFavoriteLocations.first.city ?? '');
      prefs.setString('country', updatedFavoriteLocations.first.country ?? '');
      emit(
        state.copyWith(
          isLoading: false,
          favoriteLocations: updatedFavoriteLocations,
          locations: updatedLocations,
        ),
      );
    } else {
      await db.delete(
        'locations',
        where: 'id = ?',
        whereArgs: [
          event.id,
        ],
      );
      await db.insert(
        'favorite_locations',
        LocationModel(
          city: event.city,
          country: event.country,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      final List<Map<String, dynamic>> updatedLocationsMaps =
          await db.query('locations');
      final List<Map<String, dynamic>> updatedFavoriteLocationsMaps =
          await db.query('favorite_locations');
      List<LocationModel> updatedLocations =
          List.generate(updatedLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedLocationsMaps[i]['id'],
          city: updatedLocationsMaps[i]['city'],
          country: updatedLocationsMaps[i]['country'],
        );
      });
      List<LocationModel> updatedFavoriteLocations =
          List.generate(updatedFavoriteLocationsMaps.length, (i) {
        return LocationModel(
          id: updatedFavoriteLocationsMaps[i]['id'],
          city: updatedFavoriteLocationsMaps[i]['city'],
          country: updatedFavoriteLocationsMaps[i]['country'],
        );
      });
      prefs.setString('city', updatedFavoriteLocations.first.city ?? '');
      prefs.setString('country', updatedFavoriteLocations.first.country ?? '');
      emit(
        state.copyWith(
          isLoading: false,
          favoriteLocations: updatedFavoriteLocations,
          locations: updatedLocations,
        ),
      );
    }
  }

  _onDeleteLocation(
      SqfliteDeleteLocationEvent event, Emitter<SqfliteState> emit) async {
    emit(state.copyWith(isLoading: true));
    final db = await openDatabase(
      join(await getDatabasesPath(), 'locations.db'),
    );
    await db.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [
        event.id,
      ],
    );
    final List<Map<String, dynamic>> updatedLocationsMaps =
        await db.query('locations');
    final List<Map<String, dynamic>> updatedFavoriteLocationsMaps =
        await db.query('favorite_locations');
    List<LocationModel> updatedLocations =
        List.generate(updatedLocationsMaps.length, (i) {
      return LocationModel(
        id: updatedLocationsMaps[i]['id'],
        city: updatedLocationsMaps[i]['city'],
        country: updatedLocationsMaps[i]['country'],
      );
    });
    List<LocationModel> updatedFavoriteLocations =
        List.generate(updatedFavoriteLocationsMaps.length, (i) {
      return LocationModel(
        id: updatedFavoriteLocationsMaps[i]['id'],
        city: updatedFavoriteLocationsMaps[i]['city'],
        country: updatedFavoriteLocationsMaps[i]['country'],
      );
    });
    emit(
      state.copyWith(
        isLoading: false,
        favoriteLocations: updatedFavoriteLocations,
        locations: updatedLocations,
      ),
    );
  }
}
