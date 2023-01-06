import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/theme.dart';
import 'package:my_weather_app/splash_screen.dart';

void main() {
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
          create: (context) => WeatherBloc()
            ..add(WeatherGetWeatherEvent())
            ..add(WeatherGetSeveralWeatherEvent()),
        ),
        BlocProvider(
          create: (context) => CityBloc()..add(CityGetCititesEvent()),
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
