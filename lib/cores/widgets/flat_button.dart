// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cscc_app/cores/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlatButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color colour;
  const FlatButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        
        backgroundColor: colour,
        foregroundColor: Colors.white,
        elevation: 2,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      
      onPressed: onPressed,
      child:  
      
       Text(
        text,
        style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 18)),
      ),
    );
  }
}
