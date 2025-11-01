import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/features/screens/add_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,

      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 0.9,
          child: Stack(
            children: [
              Positioned(
                top: 60,
                left: 10,
                child: Text(
                  " PROJECTS",
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),

                  child: Column(children: []),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPostScreen()),
            );
          },
          icon: Icon(Iconsax.add),
        ),
      ),
    );
  }
}
