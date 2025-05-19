import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText extends StatelessWidget {
  final String title;
  final String fontFamily;
  final TextAlign alignment;
  final TextOverflow txtOverFlow;
  final FontStyle style;
  final double letterSpacce;
  final Color color;
  final Color decorationColor;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  final double size;
  final double height;
  final int maxLine;
  const CustomText({
    super.key,
    this.maxLine = 5,
    this.size = 14,
    this.fontWeight = FontWeight.normal,
    this.textDecoration = TextDecoration.none,
    this.color = Colors.black,
    this.decorationColor = Colors.black,
    this.letterSpacce = 0,
    this.style = FontStyle.normal,
    this.alignment = TextAlign.start,
    this.txtOverFlow = TextOverflow.ellipsis,
    this.height = 1.0,
    required this.title,
    this.fontFamily = 'Poppins',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr,
      textAlign: alignment,
      maxLines: maxLine,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontStyle: style,
        letterSpacing: letterSpacce,
        fontFamily: fontFamily,
        color: color,
        decoration: textDecoration,
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: decorationColor,
        fontWeight: fontWeight,
        fontSize: size,
        height: height,
      ),
    );
  }
}
