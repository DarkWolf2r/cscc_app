import 'package:flutter/material.dart';

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light ,
    colorScheme: ColorScheme.light(
      surface:  Colors.white,
      inverseSurface: Colors.black
    )
  );
   ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark ,
    colorScheme: ColorScheme.dark(
      surface:  Colors.black,
      inverseSurface: Colors.white 
    )
  );

