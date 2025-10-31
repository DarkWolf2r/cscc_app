import 'package:cscc_app/cores/colors.dart';
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
  String? themeValue = "System mode";
  bool notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Settings"),

        // centerTitle: true,
        // backgroundColor: colorScheme.primary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Appearance",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionContainer(context, [
              _buildThemeTile("Light mode", ThemeMode.light),
              _buildThemeTile("Dark mode", ThemeMode.dark),
              _buildThemeTile("System mode", ThemeMode.system),
            ]),
            const SizedBox(height: 25),

            Text(
              "Preferences",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionContainer(context, [
              SwitchListTile(
                title: Text(
                  "Enable Notifications",
                  style: GoogleFonts.lato(fontSize: 18),
                ),
                secondary: const Icon(Icons.notifications_active_outlined),
                activeThumbColor: primaryColor,
                value: notificationsOn,
                onChanged: (value) {
                  setState(() => notificationsOn = value);
                },
              ),
            ]),

            const SizedBox(height: 25),
            Text(
              "Account",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildSectionContainer(context, [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("About the App"),
                onTap: () {
                  _showInfoDialog(
                    context,
                    "About the App",
                    "This app helps manage CSCC members and their activities efficiently.",
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Help & Support"),
                onTap: () {
                  _showInfoDialog(
                    context,
                    "Help",
                    "For support, please contact cscc.team@gmail.com",
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock_reset),
                title: const Text("Reset Password"),
                onTap: () {
                  _showInfoDialog(
                    context,
                    "Reset Password",
                    "Check your registered email to reset your password.",
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Logout"),
                onTap: () => _showConfirmDialog(
                  context,
                  "Logout",
                  "Are you sure you want to logout?",
                  () {
                    ref.read(authServiceProvider).signOutUser();
                    Navigator.pop(context);
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text("Delete Account"),
                onTap: () => _showConfirmDialog(
                  context,
                  "Delete Account",
                  "This action is irreversible. Do you want to continue?",
                  () {
                    // Add delete account logic here
                    Navigator.pop(context);
                  },
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(String label, ThemeMode mode) {
    return RadioListTile<String>(
      value: label,
      groupValue: themeValue,
      title: Text(label, style: GoogleFonts.lato(fontSize: 18)),
      onChanged: (value) {
        setState(() => themeValue = value);
        final themeProvider = ref.read(appThemeProvider);
        if (mode == ThemeMode.light) {
          themeProvider.setThemeMode(ThemeMode.light);
        } else if (mode == ThemeMode.dark) {
          themeProvider.setThemeMode(ThemeMode.dark);
        } else {
          themeProvider.useSystemTheme();
        }
      },
    );
  }

  Widget _buildSectionContainer(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: GoogleFonts.lato(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: GoogleFonts.lato(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
