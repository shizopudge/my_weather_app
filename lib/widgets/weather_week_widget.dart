import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/models/weather_week_model.dart';

class WeatherWeekWeidget extends StatelessWidget {
  final List<WeatherWeekModel> weatherWeekList;
  const WeatherWeekWeidget({
    super.key,
    required this.weatherWeekList,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    final units =
        context.select<WeatherBloc, String>((value) => value.state.units);
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: weatherWeekList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
              final weather = weatherWeekList[index];
              return ListTile(
                leading: SizedBox(
                  width: 80,
                  child: Text(
                    weather.weekday ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Fonts.msgTextStyle.copyWith(fontSize: 16),
                  ),
                ),
                subtitle: const Divider(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop_outlined,
                          color: Colors.blue,
                        ),
                        Text(
                          '${weather.avgHumidity}%',
                          style: Fonts.msgTextStyle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              onError: ((exception, stackTrace) {
                                context
                                    .read<WeatherBloc>()
                                    .add(WeatherOnErrorEvent());
                              }),
                              image: NetworkImage(
                                'http://openweathermap.org/img/wn/${weather.iconDay}.png',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              onError: ((exception, stackTrace) {
                                context
                                    .read<WeatherBloc>()
                                    .add(WeatherOnErrorEvent());
                              }),
                              image: NetworkImage(
                                'http://openweathermap.org/img/wn/${weather.iconNight}.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.avgTemp ?? '',
                          style: Fonts.msgTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        if (units == 'metric')
                          Image.asset(
                            'assets/icons/celsius.png',
                            height: 9,
                            color:
                                theme == 'dark' ? Colors.white : Colors.black,
                          ),
                        if (units == 'imperial')
                          Image.asset(
                            'assets/icons/fahrenheit.png',
                            height: 9,
                            color:
                                theme == 'dark' ? Colors.white : Colors.black,
                          ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           weather.avgMinTemp ?? '',
                    //           style: Fonts.msgTextStyle.copyWith(
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //         if (units == 'metric')
                    //           Image.asset(
                    //             'assets/icons/celsius.png',
                    //             height: 7,
                    //             color:
                    //                 theme == 'dark' ? Colors.white : Colors.black,
                    //           ),
                    //         if (units == 'imperial')
                    //           Image.asset(
                    //             'assets/icons/fahrenheit.png',
                    //             height: 7,
                    //             color:
                    //                 theme == 'dark' ? Colors.white : Colors.black,
                    //           ),
                    //       ],
                    //     ),
                    //     Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           '/${weather.avgMaxTemp}',
                    //           style: Fonts.msgTextStyle.copyWith(
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //         if (units == 'metric')
                    //           Image.asset(
                    //             'assets/icons/celsius.png',
                    //             height: 7,
                    //             color:
                    //                 theme == 'dark' ? Colors.white : Colors.black,
                    //           ),
                    //         if (units == 'imperial')
                    //           Image.asset(
                    //             'assets/icons/fahrenheit.png',
                    //             height: 7,
                    //             color:
                    //                 theme == 'dark' ? Colors.white : Colors.black,
                    //           ),
                    //       ],
                    //     ),
                    //     Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           '/${weather.avgTemp}',
                    //           style: Fonts.msgTextStyle.copyWith(
                    //             fontSize: 14,
                    //           ),
                    //         ),
                    //         if (units == 'metric')
                    //           Image.asset(
                    //             'assets/icons/celsius.png',
                    //             height: 7,
                    //             color:
                    //                 theme == 'dark' ? Colors.white : Colors.black,
                    //           ),
                    //         if (units == 'imperial')
                    //           Image.asset(
                    //             'assets/icons/fahrenheit.png',
                    //             height: 7,
                    //             color:
                    //                 theme == 'dark' ? Colors.white : Colors.black,
                    //           ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
