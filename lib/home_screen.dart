import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/images.dart';
import 'package:my_weather_app/location_screen.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/widgets/drawer.dart';
import 'package:my_weather_app/widgets/weather_addition_widget.dart';
import 'package:my_weather_app/widgets/weather_main_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: ConstImages.mainBg,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: ((context, state) {
              final weather = state.weather;
              if (state.isError) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        elevation: 0,
                        floating: true,
                        snap: true,
                        collapsedHeight: height * .15,
                        expandedHeight: height * .25,
                        centerTitle: true,
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
                    },
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        const LocationScreen()),
                                  ),
                                );
                              },
                              child: const Text(
                                'Change location',
                                style: Fonts.headerTextStyle,
                              ),
                            ),
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

              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!state.isError && !state.isLoading && !isKeyboard) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        elevation: 0,
                        floating: true,
                        snap: true,
                        collapsedHeight: height * .15,
                        expandedHeight: height * .25,
                        centerTitle: true,
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
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          WeatherMainWidget(
                            weather: weather,
                            weatherList: state.weatherList,
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ),
      ),
    );
  }
}
