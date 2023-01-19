import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/models/weather_model.dart';

class WeatherMainWidget extends StatelessWidget {
  final WeatherModel currentWeather;
  final List<WeatherModel> weather24hList;
  const WeatherMainWidget({
    super.key,
    required this.currentWeather,
    required this.weather24hList,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    final units =
        context.select<WeatherBloc, String>((value) => value.state.units);
    return Card(
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
                    currentWeather.cityName ?? '',
                    style: Fonts.msgTextStyle.copyWith(fontSize: 21),
                  ),
                  Row(
                    children: [
                      Text(
                        '${DateFormat('MMMEd').format(DateTime.now())}, ',
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm').format(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: Fonts.msgTextStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                      onError: ((exception, stackTrace) {
                        context.read<WeatherBloc>().add(WeatherOnErrorEvent());
                      }),
                      image: NetworkImage(
                        'http://openweathermap.org/img/wn/${currentWeather.icon}.png',
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentWeather.temp.toString(),
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
                  '${currentWeather.weatherMain}/${currentWeather.weatherDescription}',
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
                            '${currentWeather.tempMin}',
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
                            '/${currentWeather.tempMax}',
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
                            '${currentWeather.tempMin}',
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
                            '/${currentWeather.tempMax}',
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
                      'Feels like ${currentWeather.feelsLike}',
                      style: Fonts.msgTextStyle.copyWith(
                        fontSize: 14,
                        letterSpacing: .5,
                      ),
                    ),
                    if (units == 'metric')
                      Image.asset(
                        'assets/icons/celsius.png',
                        height: 9,
                        color: theme == 'dark' ? Colors.white : Colors.black,
                      ),
                    if (units == 'imperial')
                      Image.asset(
                        'assets/icons/fahrenheit.png',
                        height: 9,
                        color: theme == 'dark' ? Colors.white : Colors.black,
                      ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SizedBox(
                    height: 125,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weather24hList.length,
                      itemBuilder: ((context, index) {
                        final weather = weather24hList[index];
                        return Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('HH:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      (weather.dt ?? 0) * 1000),
                                ),
                                style: Fonts.msgTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    onError: ((exception, stackTrace) {
                                      context
                                          .read<WeatherBloc>()
                                          .add(WeatherOnErrorEvent());
                                    }),
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
                                    weather.temp ?? '',
                                    style: Fonts.msgTextStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (units == 'metric')
                                    Image.asset(
                                      'assets/icons/celsius.png',
                                      height: 7,
                                      color: theme == 'dark'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  if (units == 'imperial')
                                    Image.asset(
                                      'assets/icons/fahrenheit.png',
                                      height: 7,
                                      color: theme == 'dark'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.water_drop,
                                      color: Colors.blue,
                                      size: 21,
                                    ),
                                    Text(
                                      '${weather.humidity}%',
                                      style: Fonts.msgTextStyle.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
