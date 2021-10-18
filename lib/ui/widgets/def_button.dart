import 'package:books_app/ui/constants.dart';
import 'package:books_app/ui/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double? width;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double borderRadius;

  final Color backColor;
  const DefButton(
      {Key? key,
      this.borderRadius = 40,
      this.textStyle = const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 26),
      required this.text,
      this.backColor = mainColor,
      required this.onTap,
      this.width,
      this.padding = const EdgeInsets.symmetric(vertical: 16)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefTapAnimation(
      end: 0.95,
      onTap: () {
        onTap();
      },
      child: Container(
        width: width,
        padding: padding,
        alignment: width == double.infinity ? Alignment.center : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backColor,
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}
