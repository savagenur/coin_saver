import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.brandBlue,
    textTheme: GoogleFonts.ubuntuTextTheme(),
    
    
  );
  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.brandBlue,
    textTheme: GoogleFonts.ubuntuTextTheme(),
    
    
  );
}
