// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final int? maxLines;
  const MyTextField({
    Key? key,
    this.suffixIcon,
    required this.prefixIcon,
    required this.labelText,
    this.keyboardType,
    required this.contoller,
    required this.hintText,
    this.autofillHints,
    this.validator,
    required this.obscureText,
    this.focusNode,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      autofillHints: autofillHints,
      focusNode: focusNode,
      controller: contoller,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
      // maxLines: maxLines,
      // maxLines: obscureText ? 1 : (maxLines ?? 1),
      // InputBorder? focusedBorder,
      cursorColor: Color(0xFF4A8BFF),
      style: TextStyle(
        color: Theme.of(context).colorScheme.inverseSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.red),
        ),
        prefixIcon: Icon(prefixIcon, color: Color(0xFF4A8BFF)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Color(0xFF4A8BFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Color(0xFF4A8BFF)),
        ),
        floatingLabelStyle: TextStyle(color: Color(0xFF4A8BFF)),
        // filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
