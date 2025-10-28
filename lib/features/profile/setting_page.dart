import 'package:cscc_app/cores/dark_theme/theme_page.dart';
import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  String? themeOption;
  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "General",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                height: 240,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5,
                      ),
                      child: ExpansionTile(
                        collapsedTextColor: Colors.blueGrey,
                        title: Text(
                          "Theme",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        children: [
                          ListTile(
                            onTap: () {},
                            title: const Text("Light Mode"),
                            leading: Radio(
                              value: "Light mode",
                              groupValue: themeOption,
                              onChanged: (value) {
                                setState(() {
                                  themeOption = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            title: const Text("Dark Mode"),
                            leading: Radio(
                              value: "Dark mode",
                              groupValue: themeOption,
                              onChanged: (value) {
                                setState(() {
                                  themeOption = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              () {};
                            },
                            title: const Text("System"),
                            leading: Radio(
                              value: "System",
                              groupValue: themeOption,
                              onChanged: (value) {
                                setState(() {
                                  themeOption = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Spacer(),
              
            ],
          ),
        ),
      ),
    );
  }
}
