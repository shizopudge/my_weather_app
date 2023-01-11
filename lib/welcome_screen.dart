import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_weather_app/bloc/local/local_bloc.dart';
import 'package:my_weather_app/constants/font.dart';
import 'package:my_weather_app/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme =
        context.select<LocalBloc, String>((value) => value.state.theme);
    return Scaffold(
      backgroundColor: theme == 'light' ? Colors.white : Colors.black,
      body: BlocConsumer<LocalBloc, LocalState>(listener: ((context, state) {
        if (state.isFirstLaunch == false && !state.isLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      }), builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade800, Colors.blueGrey.shade800],
            ),
          ),
          child: SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/cloud.png',
                        height: height * .3,
                      ),
                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else
                        const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      !state.isLoading
                          ? 'Hi, thanks for installing my weather forecast app, press continue to start!'
                          : 'Loading...',
                      textAlign: TextAlign.center,
                      style: Fonts.msgTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                  if (!state.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: InkWell(
                        radius: 120,
                        borderRadius: BorderRadius.circular(21),
                        onTap: () {
                          context
                              .read<LocalBloc>()
                              .add(LocalSetLaunchStateEvent());
                        },
                        onLongPress: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink.shade300,
                                Colors.indigo.shade300,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Continue',
                            style: Fonts.msgTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
