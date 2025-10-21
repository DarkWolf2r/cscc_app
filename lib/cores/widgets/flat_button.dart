
import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: colour,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
