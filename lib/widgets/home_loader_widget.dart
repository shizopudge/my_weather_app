import 'package:flutter/material.dart';

class HomeLoaderWidget extends StatelessWidget {
  const HomeLoaderWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/cloud.png',
        height: height * .35,
      ),
    );
  }
}
