import 'package:flutter/material.dart';
import 'package:my_weather_app/constants/font.dart';

class AdditionInfoListTile extends StatelessWidget {
  final String trailing;
  final String title;
  final AssetImage leading;
  const AdditionInfoListTile({
    super.key,
    required this.trailing,
    required this.title,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: leading,
              ),
            ),
          ),
          title: Text(
            title,
            style: Fonts.msgTextStyle.copyWith(fontSize: 18),
          ),
          trailing: Text(
            trailing,
            style: Fonts.msgTextStyle.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
