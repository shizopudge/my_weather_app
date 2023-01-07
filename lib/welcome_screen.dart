import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    return Scaffold(
      backgroundColor: theme == 'light' ? Colors.white : Colors.black,
      body: BlocConsumer<LocalBloc, LocalState>(
        listener: ((context, state) {
          if (state.isFirstLaunch == false && !state.isLoading) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        }),
        builder: (context, state) {
          return state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<LocalBloc>().add(LocalSetLaunchStateEvent());
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
