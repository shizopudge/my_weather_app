import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/city/city_bloc.dart';
import 'package:my_weather_app/bloc/countries/country_bloc.dart';
import 'package:my_weather_app/bloc/countries/country_event.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc()
            ..add(
              WeatherGetWeatherEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => CountryBloc()
            ..add(
              CountryGetCountriesEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => CityBloc(),
        ),
        BlocProvider(
          create: (context) => LocalBloc()
            ..add(
              LocalGetLaunchStateEvent(),
            ),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const SplashScreen(),
      ),
    );
  }
}
