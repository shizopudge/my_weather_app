import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/images.dart';
import 'package:my_weather_app/widgets/drawer.dart';
import 'package:my_weather_app/widgets/home_error_widget.dart';
import 'package:my_weather_app/widgets/home_loader_widget.dart';
import 'package:my_weather_app/widgets/home_weather_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final theme = context.select<LocalBloc, String>((bloc) => bloc.state.theme);
    return Scaffold(
      drawer: const LeftDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ConstImages.bg,
            colorFilter: theme == 'dark'
                ? const ColorFilter.mode(
                    Colors.cyan,
                    BlendMode.darken,
                  )
                : null,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: ((context, state) {
              final weather = state.weather;
              final weather24hList = state.weather24hList;
              final weatherWeekList = state.weatherWeekList;
              final city = state.city;
              final country = state.country;
              if (state.isError) {
                return HomeErrorWidget(
                  height: height,
                  city: city,
                  country: country,
                );
              }
              if (state.isLoading &&
                  (weather.cityName == null ||
                      weather.clouds == null ||
                      weather.dt == null ||
                      weather.feelsLike == null ||
                      weather.humidity == null ||
                      weather.icon == null ||
                      weather.pressure == null ||
                      weather.sunrise == null ||
                      weather.sunset == null ||
                      weather.temp == null ||
                      weather.tempMax == null ||
                      weather.tempMin == null ||
                      weather.weatherDescription == null ||
                      weather.weatherMain == null ||
                      weather.windSpeed == null ||
                      weatherWeekList == [] ||
                      weather24hList == [])) {
                return HomeLoaderWidget(height: height);
              }
              if (state.isLoading &&
                  (weather.cityName != null &&
                      weather.clouds != null &&
                      weather.dt != null &&
                      weather.feelsLike != null &&
                      weather.humidity != null &&
                      weather.icon != null &&
                      weather.pressure != null &&
                      weather.sunrise != null &&
                      weather.sunset != null &&
                      weather.temp != null &&
                      weather.tempMax != null &&
                      weather.tempMin != null &&
                      weather.weatherDescription != null &&
                      weather.weatherMain != null &&
                      weather.windSpeed != null &&
                      weatherWeekList != [] &&
                      weather24hList != [])) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!state.isError && !state.isLoading && !isKeyboard) {
                if (weather.cityName != null &&
                    weather.clouds != null &&
                    weather.dt != null &&
                    weather.feelsLike != null &&
                    weather.humidity != null &&
                    weather.icon != null &&
                    weather.pressure != null &&
                    weather.sunrise != null &&
                    weather.sunset != null &&
                    weather.temp != null &&
                    weather.tempMax != null &&
                    weather.tempMin != null &&
                    weather.weatherDescription != null &&
                    weather.weatherMain != null &&
                    weather.windSpeed != null &&
                    weatherWeekList != [] &&
                    weather24hList != []) {
                  return HomeWeatherWidget(
                    height: height,
                    weather: weather,
                    weather24hList: weather24hList,
                    weatherWeekList: weatherWeekList,
                    city: city,
                    country: country,
                  );
                }
                if (weather.cityName == null ||
                    weather.clouds == null ||
                    weather.dt == null ||
                    weather.feelsLike == null ||
                    weather.humidity == null ||
                    weather.icon == null ||
                    weather.pressure == null ||
                    weather.sunrise == null ||
                    weather.sunset == null ||
                    weather.temp == null ||
                    weather.tempMax == null ||
                    weather.tempMin == null ||
                    weather.weatherDescription == null ||
                    weather.weatherMain == null ||
                    weather.windSpeed == null ||
                    weatherWeekList == [] ||
                    weather24hList == []) {
                  return HomeErrorWidget(
                    height: height,
                    city: city,
                    country: country,
                  );
                }
                return HomeLoaderWidget(height: height);
              }
              return HomeLoaderWidget(height: height);
            }),
          ),
        ),
      ),
    );
  }
}
