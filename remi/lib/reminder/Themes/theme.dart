import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes{

}
TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold
    )
  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 29,
          fontWeight: FontWeight.bold
      )
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700
    )
  );
}
TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400
      )
  );
}