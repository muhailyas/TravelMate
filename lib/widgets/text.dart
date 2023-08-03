import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const mainHeadingTextStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
subHeadingTextStyle({Color? color, double? fontsize, dynamic fontweight}) {
  return TextStyle(
      fontSize: fontsize ?? 25,
      fontWeight: fontweight ?? FontWeight.bold,
      color: color ?? Colors.black);
}

const formFielTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);

googleFontStyle(
    {Color color = Colors.black,
    double fontsize = 20,
    dynamic fontweight = FontWeight.w100,
    double letterSpacing = 0}) {
  return GoogleFonts.sourceSansPro(
      color: color,
      fontSize: fontsize,
      fontWeight: fontweight,
      letterSpacing: letterSpacing);
}
