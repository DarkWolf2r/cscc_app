import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DepartementPage extends StatelessWidget {
  const DepartementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Department data with icons
    final departments = [
      {'name': 'DEVELOPMENT', 'icon': Icons.computer},
      {'name': 'SECURITY', 'icon': Icons.security},
      {'name': 'ROBOTICS', 'icon': Icons.smart_toy},
      {'name': 'COMMUNICATION', 'icon': Icons.connect_without_contact},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF4A8BFF),
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 10,
            child: Text(
              "DEPARTEMENT",
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
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: departments.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              departments[index]['icon'] as IconData,
                              size: 40,
                              color: const Color(0xFF4A8BFF),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              departments[index]['name'] as String,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
