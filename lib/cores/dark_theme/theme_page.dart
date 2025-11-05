import 'package:flutter/material.dart';

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light ,
    colorScheme: ColorScheme.light(
      surface:  Colors.white,
      inverseSurface: Colors.black,
     // onSurface: Colors.grey.shade300,
    )
  );
   ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark ,
    colorScheme: ColorScheme.dark(
      // surface:  Colors.black,
      surface:  Color(0xFF181B2E),
      inverseSurface: Colors.white,
    //  onSurface: Colors.grey.shade700, 
    )
  );

