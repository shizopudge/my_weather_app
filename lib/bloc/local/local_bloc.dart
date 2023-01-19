import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/models/geo_location_model.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'local_event.dart';
part 'local_state.dart';

class LocalBloc extends Bloc<LocalEvent, LocalState> {
  LocalBloc() : super(LocalState()) {
    on<LocalSetLaunchStateEvent>(_onSetLaunchState);
    on<LocalGetLaunchStateEvent>(_onGetLaunchState);
    on<LocalSetThemeStateEvent>(_onSetThemeState);
    on<LocalSetFirstLaunchGeo>(_onSetFirstLaunchGeoState);
    // on<LocalSetupNotificationsEvent>(_onSetupNotifications);
  }
  final _httpClient = Dio(
    BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 25000,
    ),
  );

  _onSetLaunchState(
      LocalSetLaunchStateEvent event, Emitter<LocalState> emit) async {
    if (event.isFirstLaunchWithGeo) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.unableToDetermine ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        emit(
          state.copyWith(
            isLoading: true,
          ),
        );
        final prefs = await SharedPreferences.getInstance();
        final currentPosition = await Geolocator.getCurrentPosition();
        final res = await _httpClient.get(
            'https://api.geoapify.com/v1/geocode/reverse?lat=${currentPosition.latitude}&lon=${currentPosition.longitude}&apiKey=0de2b91f45964cea8ab3ab92d27939b2');
        if (res.statusCode == 200) {
          final geo = GeoModel.fromJson(res.data);
          if (geo.city != null && geo.country != null) {
            await prefs.setString('city', geo.city ?? '');
            await prefs.setString('country', geo.country ?? '');
            await prefs.setString('units', 'metric');
            final db = await openDatabase(
              join(await getDatabasesPath(), 'locations.db'),
              onCreate: (db, version) {
                db.execute(
                  'CREATE TABLE locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)',
                );
                db.execute(
                    'create table favorite_locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)');
              },
              version: 1,
            );
            await db.insert(
                'locations',
                LocationModel(city: geo.city ?? '', country: geo.country ?? '')
                    .toMap());
            await prefs.setBool('isFirstLaunch', false);
          } else {
            await prefs.setString('city', 'Error');
            await prefs.setString('country', 'Error');
            await prefs.setString('units', 'metric');
            await openDatabase(
              join(await getDatabasesPath(), 'locations.db'),
              onCreate: (db, version) {
                db.execute(
                  'CREATE TABLE locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)',
                );
                db.execute(
                    'create table favorite_locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)');
              },
              version: 1,
            );
            await prefs.setBool('isFirstLaunch', false);
          }
          emit(
            state.copyWith(
              isFirstLaunch: false,
              isLoading: false,
            ),
          );
        }
      }
    } else {
      emit(state.copyWith(isLoading: true));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('city', 'Moscow');
      await prefs.setString('country', 'Russia');
      await prefs.setString('units', 'metric');
      final db = await openDatabase(
        join(await getDatabasesPath(), 'locations.db'),
        onCreate: (db, version) {
          db.execute(
            'CREATE TABLE locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)',
          );
          db.execute(
              'create table favorite_locations(id INTEGER PRIMARY KEY autoincrement, city TEXT, country TEXT)');
        },
        version: 1,
      );
      await db.insert('locations',
          LocationModel(city: 'Moscow', country: 'Russia').toMap());
      await prefs.setBool('isFirstLaunch', false);
      emit(
        state.copyWith(
          isFirstLaunch: false,
          isLoading: false,
        ),
      );
    }
  }

  _onGetLaunchState(
      LocalGetLaunchStateEvent event, Emitter<LocalState> emit) async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch');
    final theme = prefs.getString('theme') ?? 'light';
    if (isFirstLaunch ?? true) {
      prefs.setString('theme', 'light');
      emit(
        state.copyWith(
          isFirstLaunch: true,
          theme: theme,
          isLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFirstLaunch: false,
          theme: theme,
          isLoading: false,
        ),
      );
    }
  }

  _onSetThemeState(
      LocalSetThemeStateEvent event, Emitter<LocalState> emit) async {
    emit(
      state.copyWith(isLoading: true),
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'theme',
      event.theme,
    );
    emit(
      state.copyWith(
        isFirstLaunch: false,
        isLoading: false,
        theme: event.theme,
      ),
    );
  }

  _onSetFirstLaunchGeoState(
      LocalSetFirstLaunchGeo event, Emitter<LocalState> emit) async {
    emit(
      state.copyWith(
        isFirstLaunchWithGeo: event.value,
        isFirstLaunch: true,
      ),
    );
  }

  // _onSetupNotifications(
  //     LocalSetupNotificationsEvent event, Emitter<LocalState> emit) async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //   AndroidInitializationSettings androidInitialize =
  //       const AndroidInitializationSettings('@drawable/ic_launcher');
  //   DarwinInitializationSettings iosInitialize =
  //       const DarwinInitializationSettings();
  //   InitializationSettings initializationsSetting =
  //       InitializationSettings(android: androidInitialize, iOS: iosInitialize);
  //   await flutterLocalNotificationsPlugin.initialize(initializationsSetting);
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       const AndroidNotificationDetails(
  //     'AndroidNoti',
  //     'Weather Forecast',
  //     importance: Importance.max,
  //     priority: Priority.max,
  //   );
  //   final platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: const DarwinNotificationDetails(),
  //   );
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final isFirstLaunch = prefs.getBool('isFirstLaunch');
  //   if (isFirstLaunch ?? true) {
  //     return;
  //   } else {
  //     final db = await openDatabase(
  //       join(await getDatabasesPath(), 'locations.db'),
  //     );
  //     tz.initializeTimeZones();
  //     final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
  //     tz.setLocalLocation(tz.getLocation(timeZone));
  //     final List<Map<String, dynamic>> favoriteLocationsMaps =
  //         await db.query('favorite_locations');
  //     List<LocationModel> favoriteLocations =
  //         List.generate(favoriteLocationsMaps.length, (i) {
  //       return LocationModel(
  //         id: favoriteLocationsMaps[i]['id'],
  //         city: favoriteLocationsMaps[i]['city'],
  //         country: favoriteLocationsMaps[i]['country'],
  //       );
  //     });
  //     if (favoriteLocations.isNotEmpty) {
  //       final String? units = prefs.getString('units');
  //       final Response res = await _httpClient.get(
  //           'https://api.openweathermap.org/data/2.5/weather',
  //           queryParameters: {
  //             'q': favoriteLocations.first.city,
  //             'units': units,
  //             'appid': '476834e607173de250e2b4595cc852af',
  //           });
  //       if (res.statusCode == 200) {
  //         final WeatherModel weather = WeatherModel.fromJson(res.data);
  //         tz.TZDateTime convertTime(int hour, int minutes) {
  //           final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //           tz.TZDateTime scheduleDate = tz.TZDateTime(
  //             tz.local,
  //             now.year,
  //             now.month,
  //             now.day,
  //             hour,
  //             minutes,
  //           );
  //           if (scheduleDate.isBefore(now)) {
  //             scheduleDate = scheduleDate.add(
  //               const Duration(days: 1),
  //             );
  //           }
  //           return scheduleDate;
  //         }

  //         await flutterLocalNotificationsPlugin.zonedSchedule(
  //           1,
  //           '${weather.temp}° ${weather.cityName}',
  //           '${weather.weatherMain}/${weather.weatherDescription}\n${weather.tempMax}°/${weather.tempMin}°',
  //           convertTime(7, 0),
  //           platformChannelSpecifics,
  //           uiLocalNotificationDateInterpretation:
  //               UILocalNotificationDateInterpretation.absoluteTime,
  //           androidAllowWhileIdle: true,
  //           matchDateTimeComponents: DateTimeComponents.time,
  //         );
  //       } else {
  //         throw Exception('Something went wrong');
  //       }
  //     }
  //   }
  // }
}
