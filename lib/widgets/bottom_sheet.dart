import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_bloc.dart';
import 'package:my_weather_app/bloc/weather/weather_event.dart';
import 'package:my_weather_app/constants/arrays.dart';
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
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: Colors.grey,
      ),
      child: SizedBox(
        height: height * .2,
        child: ListWheelScrollView.useDelegate(
          controller: _unitsController,
          itemExtent: 50,
          perspective: 0.005,
          diameterRatio: 1.2,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (value) {
            if (weatherBloc.state.units != units[value]) {
              weatherBloc.add(
                WeatherSetUnitsEvent(
                  units: units[value],
                ),
              );
              weatherBloc.add(
                WeatherGetWeatherEvent(),
              );
            }
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: units.length,
            builder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  units[index],
                  style: Fonts.headerTextStyle,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
