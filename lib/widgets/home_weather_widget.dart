import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_bloc.dart';
import 'package:my_weather_app/bloc/sqflite/sqflite_event.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/location_screen.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:my_weather_app/models/weather_week_model.dart';
import 'package:my_weather_app/widgets/weather_addition_widget.dart';
import 'package:my_weather_app/widgets/weather_main_widget.dart';
import 'package:my_weather_app/widgets/weather_week_widget.dart';

class HomeWeatherWidget extends StatelessWidget {
  const HomeWeatherWidget({
    Key? key,
    required this.height,
    required this.weather,
    required this.weather24hList,
    required this.weatherWeekList,
    required this.city,
    required this.country,
  }) : super(key: key);

  final double height;
  final WeatherModel weather;
  final List<WeatherModel> weather24hList;
  final List<WeatherWeekModel> weatherWeekList;
  final String city;
  final String country;

  @override
  Widget build(BuildContext context) {
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
                context.read<SqfliteBloc>().add(SqfliteGetLocationsEvent());
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
                      builder: ((context) => const LocationScreen()),
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
                        city,
                        textAlign: TextAlign.center,
                        style: Fonts.headerTextStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        country,
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
                            '${DateFormat('MMMEd').format(DateTime.now())}, ',
                            textAlign: TextAlign.center,
                            style: Fonts.msgTextStyle.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(
                              DateTime.now(),
                            ),
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
          context.read<WeatherBloc>().add(WeatherGet24hWeatherEvent());
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
}
