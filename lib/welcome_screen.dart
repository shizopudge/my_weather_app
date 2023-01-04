import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocalBloc, LocalState>(
        builder: (context, state) {
          return Center(
            child: TextButton(
              onPressed: () {
                context.read<LocalBloc>().add(LocalSetLaunchStateEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Text(
                'Continue',
                style: Fonts.headerTextStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}
