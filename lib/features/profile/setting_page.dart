// import 'package:cscc_app/cores/dark_theme/theme_page.dart';
// import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SettingPage extends ConsumerStatefulWidget {
//   const SettingPage({super.key});

//   @override
//   ConsumerState<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends ConsumerState<SettingPage> {
//   String? themeOption;
//   @override
//   Widget build(BuildContext context) {
//     final appTheme = ref.watch(appThemeProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Text(
//                   "General",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 25,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 240,
//                 width: MediaQuery.sizeOf(context).width,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.black26),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30.0,
//                         vertical: 5,
//                       ),
//                       child: ExpansionTile(
//                         collapsedTextColor: Colors.blueGrey,
//                         title: Text(
//                           "Theme",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 20,
//                           ),
//                         ),
//                         children: [
//                           ListTile(
//                             onTap: () {},
//                             title: const Text("Light Mode"),
//                             leading: Radio(
//                               value: "Light mode",
//                               groupValue: themeOption,
//                               onChanged: (value) {
//                                 setState(() {
//                                   themeOption = value;
//                                 });
//                               },
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {},
//                             title: const Text("Dark Mode"),
//                             leading: Radio(
//                               value: "Dark mode",
//                               groupValue: themeOption,
//                               onChanged: (value) {
//                                 setState(() {
//                                   themeOption = value;
//                                 });
//                               },
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {
//                               () {};
//                             },
//                             title: const Text("System"),
//                             leading: Radio(
//                               value: "System",
//                               groupValue: themeOption,
//                               onChanged: (value) {
//                                 setState(() {
//                                   themeOption = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                   ],
//                 ),
//               ),
//               Spacer(),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Settings
              _buildSectionHeader('Appearance'),
              _buildSettingCard(
                context,
                child: Column(
                  children: [
                    _buildThemeOption(
                      'Light Mode',
                      Icons.light_mode,
                      appTheme.themeMode == ThemeMode.light,
                      () => appTheme.themeMode = ThemeMode.light,
                    ),
                    const Divider(),
                    _buildThemeOption(
                      'Dark Mode',
                      Icons.dark_mode,
                      appTheme.themeMode == ThemeMode.dark,
                      () => appTheme.themeMode = ThemeMode.dark,
                    ),
                    const Divider(),
                    _buildThemeOption(
                      'System',
                      Icons.settings_system_daydream,
                      appTheme.themeMode == ThemeMode.system,
                      () => appTheme.themeMode = ThemeMode.system,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Settings
              _buildSectionHeader('Account'),
              _buildSettingCard(
                context,
                child: Column(
                  children: [
                    _buildSettingTile(
                      'Profile Settings',
                      Icons.person_outline,
                      onTap: () {
                        /* TODO: Navigate to profile settings */
                      },
                    ),
                    const Divider(),
                    _buildSettingTile(
                      'Notification Settings',
                      Icons.notifications_none,
                      onTap: () {
                        /* TODO: Navigate to notifications */
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App Information
              _buildSectionHeader('About'),
              _buildSettingCard(
                context,
                child: Column(
                  children: [
                    _buildSettingTile(
                      'App Version',
                      Icons.info_outline,
                      trailing: Text('1.0.0'),
                    ),
                    const Divider(),
                    _buildSettingTile(
                      'Terms of Service',
                      Icons.description_outlined,
                      onTap: () {
                        /* TODO: Show terms */
                      },
                    ),
                    const Divider(),
                    _buildSettingTile(
                      'Privacy Policy',
                      Icons.privacy_tip_outlined,
                      onTap: () {
                        /* TODO: Show privacy policy */
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Danger Zone
              _buildSettingCard(
                context,
                color: Colors.red.shade50,
                child: _buildSettingTile(
                  'Sign Out',
                  Icons.logout,
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    /* TODO: Handle sign out */
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required Widget child,
    Color? color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildThemeOption(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.poppins()),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF4A8BFF))
          : null,
    );
  }

  Widget _buildSettingTile(
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: GoogleFonts.poppins(color: textColor)),
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
    );
  }
}
