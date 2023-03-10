import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:my_weather_app/background_services/background_services.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/preload/preload_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/theme.dart';
import 'package:my_weather_app/splash_screen.dart';

import 'bloc/location/location_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundServices.initializeService();
  HomeWidget.registerBackgroundCallback(BackgroundServices.backgroundCallback);
  runApp(const MyApp());
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
