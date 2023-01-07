import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/images.dart';
import 'package:my_weather_app/location_screen.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/widgets/drawer.dart';
import 'package:my_weather_app/widgets/weather_addition_widget.dart';
import 'package:my_weather_app/widgets/weather_main_widget.dart';
import 'package:my_weather_app/widgets/weather_week_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    return Scaffold(
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ConstImages.bg,
              colorFilter: theme == 'dark'
                  ? const ColorFilter.mode(
                      Colors.blue,
                      BlendMode.darken,
                    )
                  : null,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: ((context, state) {
              final weather = state.weather;
              final weather24hList = state.weather24hList;
              final weatherWeekList = state.weatherWeekList;
              if (state.isError) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        elevation: 0,
                        collapsedHeight: height * .15,
                        expandedHeight: height * .25,
                        leadingWidth: 35,
                        backgroundColor: Colors.transparent,
                        leading: InkWell(
                          radius: 100,
                          borderRadius: BorderRadius.circular(21),
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: const Icon(
                            Icons.menu,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        actions: [
                          InkWell(
                            radius: 100,
                            borderRadius: BorderRadius.circular(21),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) =>
                                      const LocationScreen()),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        flexibleSpace: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.city,
                                    textAlign: TextAlign.center,
                                    style: Fonts.headerTextStyle.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    state.country,
                                    textAlign: TextAlign.center,
                                    style: Fonts.msgTextStyle.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Last update:',
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle.copyWith(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat('MMMEd').format(state.lastUpdate)}, ',
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle.copyWith(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(state.lastUpdate),
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle.copyWith(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.black,
                    onRefresh: () async {
                      context.read<WeatherBloc>().add(WeatherGetWeatherEvent());
                      context
                          .read<WeatherBloc>()
                          .add(WeatherGet24hWeatherEvent());
                      context.read<WeatherBloc>().add(
                            WeatherGetWeekWeatherEvent(),
                          );
                    },
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/cloud.png',
                              height: height * .35,
                            ),
                            Text(
                              'Something went wrong...',
                              textAlign: TextAlign.center,
                              style: Fonts.msgTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                return Center(
                  child: Image.asset(
                    'assets/icons/cloud.png',
                    height: height * .35,
                  ),
                );
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
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          elevation: 0,
                          collapsedHeight: height * .15,
                          expandedHeight: height * .25,
                          leadingWidth: 35,
                          backgroundColor: Colors.transparent,
                          leading: InkWell(
                            radius: 100,
                            borderRadius: BorderRadius.circular(21),
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Icon(
                              Icons.menu,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            InkWell(
                              radius: 100,
                              borderRadius: BorderRadius.circular(21),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        const LocationScreen()),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.add_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ],
                          flexibleSpace: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.city,
                                      textAlign: TextAlign.center,
                                      style: Fonts.headerTextStyle.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      state.country,
                                      textAlign: TextAlign.center,
                                      style: Fonts.msgTextStyle.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Last update:',
                                          textAlign: TextAlign.center,
                                          style: Fonts.msgTextStyle.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${DateFormat('MMMEd').format(state.lastUpdate)}, ',
                                          textAlign: TextAlign.center,
                                          style: Fonts.msgTextStyle.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(state.lastUpdate),
                                          textAlign: TextAlign.center,
                                          style: Fonts.msgTextStyle.copyWith(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.black,
                      onRefresh: () async {
                        context
                            .read<WeatherBloc>()
                            .add(WeatherGetWeatherEvent());
                        context
                            .read<WeatherBloc>()
                            .add(WeatherGet24hWeatherEvent());
                        context.read<WeatherBloc>().add(
                              WeatherGetWeekWeatherEvent(),
                            );
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            WeatherMainWidget(
                              currentWeather: weather,
                              weather24hList: weather24hList,
                            ),
                            WeatherWeekWeidget(
                              weatherWeekList: weatherWeekList,
                            ),
                            WeatherAdditionWidget(
                              weather: weather,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  Future.delayed(const Duration(seconds: 5), () {
                    return NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            elevation: 0,
                            collapsedHeight: height * .15,
                            expandedHeight: height * .25,
                            leadingWidth: 35,
                            backgroundColor: Colors.transparent,
                            leading: InkWell(
                              radius: 100,
                              borderRadius: BorderRadius.circular(21),
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: const Icon(
                                Icons.menu,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            actions: [
                              InkWell(
                                radius: 100,
                                borderRadius: BorderRadius.circular(21),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const LocationScreen()),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            flexibleSpace: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        state.city,
                                        textAlign: TextAlign.center,
                                        style: Fonts.headerTextStyle.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        state.country,
                                        textAlign: TextAlign.center,
                                        style: Fonts.msgTextStyle.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Last update:',
                                            textAlign: TextAlign.center,
                                            style: Fonts.msgTextStyle.copyWith(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${DateFormat('MMMEd').format(state.lastUpdate)}, ',
                                            textAlign: TextAlign.center,
                                            style: Fonts.msgTextStyle.copyWith(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('HH:mm')
                                                .format(state.lastUpdate),
                                            textAlign: TextAlign.center,
                                            style: Fonts.msgTextStyle.copyWith(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                        onRefresh: () async {
                          context
                              .read<WeatherBloc>()
                              .add(WeatherGetWeatherEvent());
                          context
                              .read<WeatherBloc>()
                              .add(WeatherGet24hWeatherEvent());
                          context.read<WeatherBloc>().add(
                                WeatherGetWeekWeatherEvent(),
                              );
                        },
                        child: SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/cloud.png',
                                  height: height * .35,
                                ),
                                Text(
                                  'Something went wrong...',
                                  textAlign: TextAlign.center,
                                  style: Fonts.msgTextStyle.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                }
                return Center(
                  child: Image.asset(
                    'assets/icons/cloud.png',
                    height: height * .35,
                  ),
                );
              }
              return Center(
                child: Image.asset(
                  'assets/icons/cloud.png',
                  height: height * .35,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
