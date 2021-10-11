import 'package:books_app/ui/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class DefButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double? width;
  final EdgeInsets padding;

  final Color backColor;
  const DefButton(
      {Key? key,
      required this.text,
      this.backColor = mainColor,
      required this.onTap,
      this.width,
      this.padding = const EdgeInsets.symmetric(vertical: 16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: width,
        padding: padding,
        alignment: width == double.infinity ? Alignment.center : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: backColor,
        ),
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: SizeConfig.ww * .70)),
      ),
    );
  }
}
