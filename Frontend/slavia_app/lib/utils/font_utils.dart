import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
TextStyle getFont(double size, String color, FontWeight weight) {
  return GoogleFonts.inter(
      textStyle: TextStyle(fontSize: size, color: HexColor(color), letterSpacing: 1, fontWeight: weight));
}
//montserrat