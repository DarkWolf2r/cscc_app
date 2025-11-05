// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerTile extends StatelessWidget {
  final String title;
  final Widget leading;
  final void Function() onTap;
  const ContainerTile({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
      title: const Text("Date"),
      subtitle: Text("date", style: GoogleFonts.lato(fontSize: 14)),
    );
  }
}
