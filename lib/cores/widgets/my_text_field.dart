import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final String labelText;
  final TextInputType? keyboardType;
  final TextEditingController contoller;
  final String hintText;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final bool obscureText;
  final FocusNode? focusNode;
  const MyTextField(

      {super.key,
      this.suffixIcon,
     required  this.prefixIcon,
      required this.labelText,
      this.keyboardType,
      required this.contoller,
      required this.hintText,
      required this.obscureText,
      this.focusNode,
      this.autofillHints,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        
        keyboardType: keyboardType,
        validator: validator,
        autofillHints: autofillHints,
        focusNode: focusNode,
        controller: contoller,
        obscureText: obscureText,
        cursorColor: Color(0xFF4A8BFF),
       decoration: InputDecoration(
        suffixIcon: suffixIcon,
                        labelText: labelText,
                        hintText: hintText,
                        prefixIcon: Icon(
                          prefixIcon,
                          color: Color(0xFF4A8BFF),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xFF4A8BFF)),
                        ),
                        floatingLabelStyle: TextStyle(color: Color(0xFF4A8BFF)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
      ),
    );
  }
}
