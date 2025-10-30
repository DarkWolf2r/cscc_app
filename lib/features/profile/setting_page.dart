import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
import 'package:cscc_app/cores/widgets/container_tile.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  String? themeValue;
  bool notificationsOn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "General",
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Container(
                height: 270,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Text(
                        "Theme",
                        style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    RadioListTile(
                      groupValue: themeValue,
                      value: "Light mode",
                      title: Text(
                        "Light mode",
                        style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          themeValue = value;
                        });
                        ref
                            .watch(appThemeProvider)
                            .setThemeMode(ThemeMode.light);
                      },
                    ),
                    RadioListTile(
                      groupValue: themeValue,
                      value: "Dark mode",
                      title: Text(
                        "Dark mode",
                        style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          themeValue = value;
                        });
                        ref
                            .watch(appThemeProvider)
                            .setThemeMode(ThemeMode.dark);
                      },
                    ),
                    RadioListTile(
                      groupValue: themeValue,
                      value: "System mode",
                      title: Text(
                        "System mode",
                        style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          themeValue = value;
                        });
                        ref.watch(appThemeProvider).useSystemTheme();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: Text(
                            "Notifications",
                            style: TextStyle(
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Switch(
                          value: notificationsOn,
                          onChanged: (value) {
                            setState(() {
                              notificationsOn = !notificationsOn;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "About app",
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Container(
                height: 330,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ContainerTile(
                      title: "About The app",
                      leading: Icon(Icons.info),
                      onTap: () {},
                    ),
                    ContainerTile(
                      title: "Help ",
                      leading: Icon(Icons.help),
                      onTap: () {},
                    ),
                    ContainerTile(
                      title: "Logout",
                      leading: Icon(Icons.logout),
                      onTap: () {
                        ref.read(authServiceProvider).signOutUser();
                      },
                    ),

                    ContainerTile(
                      title: "Reset Password",
                      leading: Icon(Icons.reset_tv),
                      onTap: () {},
                    ),
                    ContainerTile(
                      title: "Delete account",
                      leading: Icon(Icons.delete),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
