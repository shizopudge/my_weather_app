import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/settings/settings_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/bloc/weather/weather_state.dart';
import 'package:my_weather_app/constants/font.dart';

class UnitsChooseBottomSheet extends StatefulWidget {
  final String unitsType;
  const UnitsChooseBottomSheet({
    super.key,
    required this.unitsType,
  });

  @override
  State<UnitsChooseBottomSheet> createState() => _UnitsChooseBottomSheetState();
}

class _UnitsChooseBottomSheetState extends State<UnitsChooseBottomSheet> {
  late final FixedExtentScrollController _unitsController;
  // final List<String> units = ['metric', 'imperial', 'standart'];
  final List<String> units = ['metric', 'imperial'];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < units.length; i++) {
      if (units[i] == widget.unitsType) {
        _unitsController = FixedExtentScrollController(initialItem: i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BottomSheet(
      builder: (context) {
        return BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Units',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Fonts.msgTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: height * .2,
                        child: ListWheelScrollView.useDelegate(
                          controller: _unitsController,
                          itemExtent: 50,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (value) {
                            if (state.units != units[value]) {
                              context.read<WeatherBloc>().add(
                                    WeatherSetUnitsEvent(
                                      units: units[value],
                                    ),
                                  );
                              context.read<WeatherBloc>().add(
                                    WeatherGetWeatherEvent(),
                                  );
                              context.read<SettingsBloc>().add(
                                    SettingsInitScreenEvent(),
                                  );
                            }
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: units.length,
                            builder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: state.units == units[index]
                                      ? const Color.fromARGB(255, 238, 237, 237)
                                      : null,
                                ),
                                width: double.infinity,
                                child: index == 0
                                    ? Image.asset(
                                        'assets/icons/celsius.png',
                                        height: 32,
                                      )
                                    : Image.asset(
                                        'assets/icons/fahrenheit.png',
                                        height: 32,
                                      ),
                                // Text(
                                //   units[index],
                                //   style: Fonts.headerTextStyle,
                                //   textAlign: TextAlign.center,
                                // ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      onClosing: () {},
    );
  }
}
