// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:cscc_app/features/profile/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> departement = ['Development', 'Security', 'Robotic'];

    return ref
        .watch(currentUserProvider)
        .when(
          data: (data) {
            return Scaffold(
              backgroundColor: const Color(0xFF4A8BFF),
              //   appBar: AppBar(title: const Text('Profile'), centerTitle: true),
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 0.9,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 60,
                        left: 10,
                        child: Text(
                          " MY PROFILE",
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

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // PROFILE AND NAME ROW
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //  mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 70,
                                              backgroundImage: NetworkImage(
                                                data.profilePic!,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              data.username,
                                              //userProvider.username,
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      //NAME AND DEPARTMENT COLUMN
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                        ),
                                        child: Column(
                                          //  crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data.type.toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            for (var dept in data.departement)
                                              Text(
                                                dept,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue[600],
                                                ),
                                              ),
                                            const SizedBox(height: 30),
                                            Text(
                                              "1 Year in CSCC ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 200,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "About Me",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          data.description ??
                                              "I'am A CSCC Membre !",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                ///
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/github.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/icons8-google.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                          'assets/linkedin.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FlatButton(
                                  text: "Settings ->",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettingPage(),
                                      ),
                                    );
                                  },
                                  colour: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                                FlatButton(
                                  text: "Logout",
                                  onPressed: () => ref
                                      .read(authServiceProvider)
                                      .signOutUser(),
                                  colour: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          loading: () => CircularProgressIndicator(),
        );
  }
}
