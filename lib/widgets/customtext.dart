import 'package:flutter/material.dart';
import 'package:travelmate/Widgets/Text.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.fontSize = 30,
      this.fontWeight = FontWeight.bold,
      this.color = Colors.white});
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 12)
      ]),
      child: Text(
        text,
        style: googleFontStyle(
            fontsize: fontSize, fontweight: fontWeight, color: color),
      ),
    );
  }
}
