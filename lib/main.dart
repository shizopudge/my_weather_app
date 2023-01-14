import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/preload/preload_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/theme.dart';
import 'package:my_weather_app/models/location_model.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/splash_screen.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'bloc/location/location_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

final _httpClient = Dio(
  BaseOptions(
    connectTimeout: 15000,
    receiveTimeout: 10000,
  ),
);

@pragma('vm:entry-point')
Future backgroundCallback(uri) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'locations.db'),
  );
  final List<Map<String, dynamic>> favoriteLocationsMaps =
      await db.query('favorite_locations');
  List<LocationModel> favoriteLocations =
      List.generate(favoriteLocationsMaps.length, (i) {
    return LocationModel(
      id: favoriteLocationsMaps[i]['id'],
      city: favoriteLocationsMaps[i]['city'],
      country: favoriteLocationsMaps[i]['country'],
    );
  });
  if (favoriteLocations.isNotEmpty) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? units = prefs.getString('units');
    final Response res = await _httpClient.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': favoriteLocations.first.city,
          'units': units,
          'appid': '476834e607173de250e2b4595cc852af',
        });
    if (res.statusCode == 200) {
      await HomeWidget.saveWidgetData<String>(
          '_temp', WeatherModel.fromJson(res.data).temp ?? '');
      await HomeWidget.saveWidgetData<String>(
          '_city', favoriteLocations.first.city ?? '');
      await HomeWidget.saveWidgetData<String>(
        '_updated',
        DateFormat('dd.MM HH:mm').format(
          DateTime.fromMillisecondsSinceEpoch(
              (WeatherModel.fromJson(res.data).dt ?? 0) * 1000),
        ),
      );
      await HomeWidget.updateWidget(
          name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
    } else {
      throw Exception('Something went wrong');
    }
  } else {
    await HomeWidget.saveWidgetData<String>('_temp', '');
    await HomeWidget.saveWidgetData<String>('_city', '');
    await HomeWidget.saveWidgetData<String>('_updated', '');
    await HomeWidget.updateWidget(
        name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocalBloc()
            ..add(
              LocalGetLaunchStateEvent(),
            ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SqfliteBloc(),
        ),
        BlocProvider(
          create: (context) => PreloadBloc()
            ..add(
              PreloadPrecacheImagesEvent(context),
            ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => WeatherBloc()
            ..add(WeatherInitGetWeatherEvent())
            ..add(WeatherInitGet24hWeatherEvent())
            ..add(WeatherInitGetWeekWeatherEvent()),
        ),
        BlocProvider(
          create: (context) => LocationBloc()..add(LocationGetCititesEvent()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SettingsBloc()..add(SettingsInitScreenEvent()),
          lazy: false,
        ),
      ],
      child: BlocSelector<LocalBloc, LocalState, String>(
        selector: (state) {
          return state.theme;
        },
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state == 'light' ? AppTheme.lightTheme : AppTheme.darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
