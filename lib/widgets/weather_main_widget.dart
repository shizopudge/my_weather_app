import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/models/weather_model.dart';

class WeatherMainWidget extends StatelessWidget {
  final WeatherModel weather;
  final List<WeatherModel> weatherList;
  const WeatherMainWidget({
    super.key,
    required this.weather,
    required this.weatherList,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    return InkWell(
      onTap: () => print(weatherList.length),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName ?? '',
                      style: Fonts.msgTextStyle.copyWith(fontSize: 21),
                    ),
                    Text(
                      'Weather calculated at ${DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            (weather.dt ?? 0) * 1000),
                      )}',
                      style: Fonts.msgTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'http://openweathermap.org/img/wn/${weather.icon}.png',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.temp.toString(),
                        style: Fonts.headerTextStyle.copyWith(fontSize: 50),
                      ),
                      BlocSelector<WeatherBloc, WeatherState, String>(
                        selector: (state) {
                          return state.units;
                        },
                        builder: (context, state) {
                          if (state == 'metric') {
                            return Image.asset(
                              'assets/icons/celsius.png',
                              height: 18,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            );
                          } else {
                            return Image.asset(
                              'assets/icons/fahrenheit.png',
                              height: 18,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${weather.weatherMain}/${weather.weatherDescription}',
                    style: Fonts.msgTextStyle.copyWith(
                      fontSize: 14,
                      letterSpacing: .5,
                    ),
                  ),
                  BlocSelector<WeatherBloc, WeatherState, String>(
                    selector: (state) {
                      return state.units;
                    },
                    builder: (context, state) {
                      if (state == 'metric') {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.tempMin}',
                              style: Fonts.msgTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/celsius.png',
                              height: 9,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            ),
                            Text(
                              '/${weather.tempMax}',
                              style: Fonts.msgTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/celsius.png',
                              height: 9,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.tempMin}',
                              style: Fonts.msgTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/fahrenheit.png',
                              height: 9,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            ),
                            Text(
                              '/${weather.tempMax}',
                              style: Fonts.msgTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/fahrenheit.png',
                              height: 9,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Feels like ${weather.feelsLike}',
                        style: Fonts.msgTextStyle.copyWith(
                          fontSize: 14,
                          letterSpacing: .5,
                        ),
                      ),
                      BlocSelector<WeatherBloc, WeatherState, String>(
                        selector: (state) {
                          return state.units;
                        },
                        builder: (context, state) {
                          if (state == 'metric') {
                            return Image.asset(
                              'assets/icons/celsius.png',
                              height: 9,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            );
                          } else {
                            return Image.asset(
                              'assets/icons/fahrenheit.png',
                              height: 9,
                              color:
                                  theme == 'dark' ? Colors.white : Colors.black,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherList.length,
                      itemBuilder: ((context, index) {
                        final weather = weatherList[index];

                        return Card(
                          color: Colors.black,
                          child: Column(
                            children: [
                              Text(weather.temp ?? ''),
                              Text(
                                DateFormat('MMMEd HH:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (weather.dt ?? 0) * 1000),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
