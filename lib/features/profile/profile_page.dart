import 'package:cached_network_image/cached_network_image.dart';
import 'package:cscc_app/cores/colors.dart';
import 'package:cscc_app/cores/dark_theme/theme_provider.dart';
import 'package:cscc_app/features/auth/provider/providers.dart';
import 'package:cscc_app/features/profile/my_project_page.dart';
import 'package:cscc_app/features/profile/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? themeValue = "System mode";
  bool notificationsOn = true;

  // Widget _buildThemeTile(String label, ThemeMode mode) {
  //   return RadioListTile<String>(
  //     value: label,
  //     groupValue: themeValue,
  //     title: Text(label, style: GoogleFonts.lato(fontSize: 18)),
  //     onChanged: (value) {
  //       setState(() => themeValue = value);
  //       final themeProvider = ref.read(appThemeProvider);
  //       if (mode == ThemeMode.light) {
  //         themeProvider.setThemeMode(ThemeMode.light);
  //       } else if (mode == ThemeMode.dark) {
  //         themeProvider.setThemeMode(ThemeMode.dark);
  //       } else {
  //         themeProvider.useSystemTheme();
  //       }
  //     },
  //   );
  // }

  // Widget _buildSectionContainer(BuildContext context, List<Widget> children) {
  //   final theme = Theme.of(context);
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 300),
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     decoration: BoxDecoration(
  //       color: theme.cardColor.withOpacity(0.95),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(children: children),
  //   );
  // }

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
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(currentUserProvider)
        .when(
          data: (data) {
            return Scaffold(
              backgroundColor: primaryColor,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: primaryColor,
                    floating: true,
                    snap: true,
                    elevation: 0,
                    title: Text(
                      "My Profile",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: CachedNetworkImageProvider(
                                    data.profilePic!,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  data.username,
                                  style: GoogleFonts.lato(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                                  ),
                                ),
                                Text(
                                  data.type,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Row(
                                //   // mainAxisAlignment: MainAxisAlignment.center,
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                //   children: [
                                //     Text(
                                //       "Followers : ${data.followers}",
                                //       style: GoogleFonts.lato(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w700,
                                //         color: Theme.of(
                                //           context,
                                //         ).colorScheme.inverseSurface,
                                //       ),
                                //     ),
                                //     const SizedBox(width: 10),
                                //     Text(
                                //       "Following: ${data.following}",
                                //       style: GoogleFonts.lato(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w800,
                                //         color: Theme.of(
                                //           context,
                                //         ).colorScheme.inverseSurface,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Followers : ${data.followers ?? 0}",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.inverseSurface,
                                        ),
                                      ),
                                      Container(
                                        height: 22,
                                        width: 1.2,
                                        color: Colors.grey.shade400,
                                      ),
                                      Text(
                                        "Following : ${data.following ?? 0}",
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.inverseSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // const SizedBox(height: 15),
                                // Wrap(
                                //   spacing: 8,
                                //   runSpacing: 6,
                                //   alignment: WrapAlignment.center,
                                //   children: data.departement.map((dept) {
                                //     return Container(
                                //       padding: const EdgeInsets.symmetric(
                                //         horizontal: 14,
                                //         vertical: 8,
                                //       ),
                                //       decoration: BoxDecoration(
                                //         gradient: LinearGradient(
                                //           colors: [
                                //             primaryColor.withOpacity(0.85),
                                //             primaryColor.withOpacity(0.65),
                                //           ],
                                //           begin: Alignment.topLeft,
                                //           end: Alignment.bottomRight,
                                //         ),
                                //         borderRadius: BorderRadius.circular(25),
                                //         boxShadow: [
                                //           BoxShadow(
                                //             color: primaryColor.withOpacity(
                                //               0.3,
                                //             ),
                                //             blurRadius: 8,
                                //             offset: const Offset(0, 3),
                                //           ),
                                //         ],
                                //       ),
                                //       child: Text(
                                //         dept,
                                //         style: GoogleFonts.lato(
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 14,
                                //           letterSpacing: 0.3,
                                //         ),
                                //       ),
                                //     );
                                //   }).toList(),
                                // ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 15),
                          // Divider(color: Colors.grey),
                          const SizedBox(height: 40),
                          Text(
                            "Other settings",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // _buildSettingTile(
                          //   context,
                          //   icon: Icons.person_outline,
                          //   title: "About Me",
                          //   onTap: () {
                          //     _showInfoDialog(
                          //       context,
                          //       "About Me",
                          //       data.description?.isNotEmpty == true
                          //           ? data.description!
                          //           : "I am a CSCC Member!",
                          //     );
                          //   },
                          // ),
                          // _buildSettingTile(
                          //   context,
                          //   icon: Icons.person_outline,
                          //   title: "About Me",
                          //   onTap: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (context) => Dialog(
                          //         backgroundColor: Theme.of(
                          //           context,
                          //         ).colorScheme.surface,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(20),
                          //         ),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(20),
                          //           child: SingleChildScrollView(
                          //             child: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 Text(
                          //                   "About Me",
                          //                   style: GoogleFonts.lato(
                          //                     fontSize: 22,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Theme.of(
                          //                       context,
                          //                     ).colorScheme.inverseSurface,
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 12),
                          //                 Text(
                          //                   data.description?.isNotEmpty == true
                          //                       ? data.description!
                          //                       : "I am a CSCC Member!",
                          //                   textAlign: TextAlign.center,
                          //                   style: GoogleFonts.lato(
                          //                     fontSize: 16,
                          //                     color: Theme.of(
                          //                       context,
                          //                     ).colorScheme.inverseSurface,
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 14),
                          //                 Divider(color: Colors.grey),
                          //                 const SizedBox(height: 14),
                          //                 // Departments
                          //                 Wrap(
                          //                   spacing: 8,
                          //                   runSpacing: 6,
                          //                   alignment: WrapAlignment.center,
                          //                   children: data.departement.map((
                          //                     dept,
                          //                   ) {
                          //                     return Container(
                          //                       padding:
                          //                           const EdgeInsets.symmetric(
                          //                             horizontal: 14,
                          //                             vertical: 8,
                          //                           ),
                          //                       decoration: BoxDecoration(
                          //                         gradient: LinearGradient(
                          //                           colors: [
                          //                             primaryColor.withOpacity(
                          //                               0.85,
                          //                             ),
                          //                             primaryColor.withOpacity(
                          //                               0.65,
                          //                             ),
                          //                           ],
                          //                           begin: Alignment.topLeft,
                          //                           end: Alignment.bottomRight,
                          //                         ),
                          //                         borderRadius:
                          //                             BorderRadius.circular(8),
                          //                         boxShadow: [
                          //                           BoxShadow(
                          //                             color: primaryColor
                          //                                 .withOpacity(0.3),
                          //                             blurRadius: 8,
                          //                             offset: const Offset(
                          //                               0,
                          //                               3,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       child: Text(
                          //                         dept,
                          //                         style: GoogleFonts.lato(
                          //                           color: Colors.white,
                          //                           fontWeight: FontWeight.w600,
                          //                           fontSize: 14,
                          //                           letterSpacing: 0.3,
                          //                         ),
                          //                       ),
                          //                     );
                          //                   }).toList(),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          _buildSettingTile(
                            context,
                            icon: Icons.person_outline,
                            title: "About Me",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                          0.3,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Content
                                        Expanded(
                                          child: SingleChildScrollView(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // About Section
                                                Text(
                                                  "About Me",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    data
                                                                .description
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? data.description!
                                                        : "I am a CSCC Member!",
                                                    style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inverseSurface,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(height: 20),

                                                // Departments Section
                                                Text(
                                                  "Departments",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .inverseSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                if (data.departement.isNotEmpty)
                                                  Wrap(
                                                    spacing: 10,
                                                    runSpacing: 8,
                                                    children: data.departement.map((
                                                      dept,
                                                    ) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              primaryColor
                                                                  .withOpacity(
                                                                    0.9,
                                                                  ),
                                                              primaryColor
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                25,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: primaryColor
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    3,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          dept,
                                                          style:
                                                              GoogleFonts.lato(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0.3,
                                                              ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  )
                                                else
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor
                                                          .withOpacity(0.6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "No departments assigned",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        color: Colors.grey,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Close Button
                                        // Container(
                                        //   padding: const EdgeInsets.all(16),
                                        //   child: ElevatedButton(
                                        //     onPressed: () =>
                                        //         Navigator.pop(context),
                                        //     style: ElevatedButton.styleFrom(
                                        //       backgroundColor: primaryColor,
                                        //       padding:
                                        //           const EdgeInsets.symmetric(
                                        //             horizontal: 40,
                                        //             vertical: 12,
                                        //           ),
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(12),
                                        //       ),
                                        //     ),
                                        //     child: Text(
                                        //       "Close",
                                        //       style: GoogleFonts.lato(
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 16,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          _buildSettingTile(
                            context,
                            icon: Icons.file_open_outlined,
                            title: "My Projects",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyProjectPage(),
                                ),
                              );
                            },
                          ),

                          // _buildSectionContainer(context, [
                          //   SwitchListTile(
                          //     title: Text(
                          //       "Enable Notifications",
                          //       style: GoogleFonts.lato(fontSize: 18),
                          //     ),
                          //     secondary: const Icon(
                          //       Icons.notifications_active_outlined,
                          //     ),
                          //     activeThumbColor: primaryColor,
                          //     value: notificationsOn,
                          //     onChanged: (value) {
                          //       setState(() => notificationsOn = value);
                          //     },
                          //   ),
                          // ]),
                          // _buildSectionContainer(context, [
                          //   _buildThemeTile("Light mode", ThemeMode.light),
                          //   _buildThemeTile("Dark mode", ThemeMode.dark),
                          //   _buildThemeTile("System mode", ThemeMode.system),
                          // ]),

                          // General Settings Tile
                          // _buildSettingTile(
                          //   context,
                          //   icon: Icons.settings_outlined,
                          //   title: "General Settings",
                          //   onTap: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (context) => Dialog(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(18),
                          //         ),
                          //         backgroundColor: Theme.of(
                          //           context,
                          //         ).colorScheme.surface,
                          //         child: Padding(
                          //           padding: const EdgeInsets.symmetric(
                          //             vertical: 20,
                          //             horizontal: 18,
                          //           ),
                          //           child: SingleChildScrollView(
                          //             child: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 // Title
                          //                 Center(
                          //                   child: Text(
                          //                     "General Settings",
                          //                     style: GoogleFonts.lato(
                          //                       fontWeight: FontWeight.bold,
                          //                       fontSize: 22,
                          //                       color: primaryColor,
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 20),

                          //                 // Appearance Section
                          //                 Text(
                          //                   "Appearance",
                          //                   style: GoogleFonts.lato(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.w700,
                          //                     color: primaryColor,
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 8),
                          //                 Container(
                          //                   decoration: BoxDecoration(
                          //                     color: Theme.of(
                          //                       context,
                          //                     ).cardColor.withOpacity(0.95),
                          //                     borderRadius:
                          //                         BorderRadius.circular(14),
                          //                     boxShadow: [
                          //                       BoxShadow(
                          //                         color: Colors.black
                          //                             .withOpacity(0.05),
                          //                         blurRadius: 8,
                          //                         offset: const Offset(0, 3),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                   child: Column(
                          //                     children: [
                          //                       RadioListTile<String>(
                          //                         value: "Light",
                          //                         groupValue: themeValue,
                          //                         title: Text(
                          //                           "Light mode",
                          //                           style: GoogleFonts.lato(
                          //                             fontSize: 16,
                          //                           ),
                          //                         ),
                          //                         activeColor: primaryColor,
                          //                         onChanged: (value) {
                          //                           setState(
                          //                             () => themeValue = value,
                          //                           );
                          //                           ref
                          //                               .read(appThemeProvider)
                          //                               .setThemeMode(
                          //                                 ThemeMode.light,
                          //                               );
                          //                         },
                          //                       ),
                          //                       RadioListTile<String>(
                          //                         value: "Dark",
                          //                         groupValue: themeValue,
                          //                         title: Text(
                          //                           "Dark mode",
                          //                           style: GoogleFonts.lato(
                          //                             fontSize: 16,
                          //                           ),
                          //                         ),
                          //                         activeColor: primaryColor,
                          //                         onChanged: (value) {
                          //                           setState(
                          //                             () => themeValue = value,
                          //                           );
                          //                           ref
                          //                               .read(appThemeProvider)
                          //                               .setThemeMode(
                          //                                 ThemeMode.dark,
                          //                               );
                          //                         },
                          //                       ),
                          //                       RadioListTile<String>(
                          //                         value: "System",
                          //                         groupValue: themeValue,
                          //                         title: Text(
                          //                           "System mode",
                          //                           style: GoogleFonts.lato(
                          //                             fontSize: 16,
                          //                           ),
                          //                         ),
                          //                         activeColor: primaryColor,
                          //                         onChanged: (value) {
                          //                           setState(
                          //                             () => themeValue = value,
                          //                           );
                          //                           ref
                          //                               .read(appThemeProvider)
                          //                               .useSystemTheme();
                          //                         },
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),

                          //                 const SizedBox(height: 25),

                          //                 // Preferences Section
                          //                 Text(
                          //                   "Preferences",
                          //                   style: GoogleFonts.lato(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.w700,
                          //                     color: primaryColor,
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 8),
                          //                 Container(
                          //                   decoration: BoxDecoration(
                          //                     color: Theme.of(
                          //                       context,
                          //                     ).cardColor.withOpacity(0.95),
                          //                     borderRadius:
                          //                         BorderRadius.circular(14),
                          //                     boxShadow: [
                          //                       BoxShadow(
                          //                         color: Colors.black
                          //                             .withOpacity(0.05),
                          //                         blurRadius: 8,
                          //                         offset: const Offset(0, 3),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                   child: SwitchListTile(
                          //                     value: notificationsOn,
                          //                     activeColor: primaryColor,
                          //                     title: Text(
                          //                       "Enable Notifications",
                          //                       style: GoogleFonts.lato(
                          //                         fontSize: 16,
                          //                       ),
                          //                     ),
                          //                     secondary: const Icon(
                          //                       Icons
                          //                           .notifications_active_outlined,
                          //                     ),
                          //                     onChanged: (value) {
                          //                       setState(
                          //                         () => notificationsOn = value,
                          //                       );
                          //                     },
                          //                   ),
                          //                 ),

                          //                 const SizedBox(height: 25),
                          //                 Align(
                          //                   alignment: Alignment.center,
                          //                   child: TextButton(
                          //                     onPressed: () =>
                          //                         Navigator.pop(context),
                          //                     child: Text(
                          //                       "Close",
                          //                       style: GoogleFonts.lato(
                          //                         color: primaryColor,
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: 16,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          _buildSettingTile(
                            context,
                            icon: Icons.settings_outlined,
                            title: "General Settings",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingPage(),
                                ),
                              );
                            },
                          ),

                          _buildSettingTile(
                            context,
                            icon: Icons.lock_outline,
                            title: "Reset Password",
                            onTap: () {
                              _showInfoDialog(
                                context,
                                "Reset Password",
                                "Check your registered email to reset your password.",
                              );
                            },
                          ),

                          // const SizedBox(height: 15),
                          _buildSettingTile(
                            context,
                            icon: Icons.info_outline,
                            title: "About application",
                            onTap: () {
                              _showInfoDialog(
                                context,
                                "About the App",
                                "This app helps manage CSCC members and their activities efficiently.",
                              );
                            },
                          ),

                          _buildSettingTile(
                            context,
                            icon: Icons.help_outline,
                            title: "Help & Support",
                            onTap: () {
                              _showInfoDialog(
                                context,
                                "Help",
                                "For support, please contact cscc.team@gmail.com",
                              );
                            },
                          ),

                          _buildSettingTile(
                            context,
                            icon: Icons.feedback_outlined,
                            title: "Feedback",
                            onTap: () {
                              _showInfoDialog(
                                context,
                                "Feedback",
                                "We’d love your feedback!\nContact us at: \ncht1485@gmail.com / \n laouar.romaissa.info@gmail.com",
                              );
                            },
                          ),
                          // const SizedBox(height: 15),
                          // Center(
                          //   child: TextButton.icon(
                          //     onPressed: () => _showConfirmDialog(
                          //       context,
                          //       "Delete Account",
                          //       "This action is irreversible. Do you want to continue?",
                          //       () async {
                          //         // await ref
                          //         //     .read(authServiceProvider)
                          //         //     .deleteAccount();
                          //         if (mounted) Navigator.pop(context);
                          //       },
                          //     ),
                          //     icon: const Icon(
                          //       Icons.delete_outline,
                          //       color: Colors.red,
                          //     ),
                          //     label: const Text(
                          //       "Delete Account",
                          //       style: TextStyle(
                          //         color: Colors.red,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Center(
                          //   child: TextButton.icon(
                          //     onPressed: () => _showConfirmDialog(
                          //       context,
                          //       "Logout",
                          //       "Are you sure you want to logout?",
                          //       () async {
                          //         // await ref
                          //         //     .read(authServiceProvider)
                          //         //     .signOutUser();
                          //         if (mounted) Navigator.pop(context);
                          //       },
                          //     ),
                          //     icon: const Icon(
                          //       Icons.logout,
                          //       color: Colors.redAccent,
                          //     ),
                          //     label: const Text(
                          //       "Logout",
                          //       style: TextStyle(
                          //         color: Colors.redAccent,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 20),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logout Button
                                ElevatedButton.icon(
                                  onPressed: () => _showConfirmDialog(
                                    context,
                                    "Logout",
                                    "Are you sure you want to logout?",
                                    () async {
                                      // await ref.read(authServiceProvider).signOutUser();
                                      if (mounted) Navigator.pop(context);
                                    },
                                  ),
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Delete Account Button
                                ElevatedButton.icon(
                                  onPressed: () => _showConfirmDialog(
                                    context,
                                    "Delete Account",
                                    "This action is irreversible. Do you want to continue?",
                                    () async {
                                      // await ref.read(authServiceProvider).deleteAccount();
                                      if (mounted) Navigator.pop(context);
                                    },
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/github.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/icons8-google.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/linkedin.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (e, _) => Center(child: Text(e.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}







// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/widgets/flat_button.dart';
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:cscc_app/features/profile/my_project_page.dart';
// import 'package:cscc_app/features/profile/setting_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';


// String? themeValue = "System mode";
// bool notificationsOn = true;

// Widget _buildThemeTile(String label, ThemeMode mode) {
//   return RadioListTile<String>(
//     value: label,
//     groupValue: themeValue,
//     title: Text(label, style: GoogleFonts.lato(fontSize: 18)),
//     onChanged: (value) {
//       setState(() => themeValue = value);
//       final themeProvider = ref.read(appThemeProvider);
//       if (mode == ThemeMode.light) {
//         themeProvider.setThemeMode(ThemeMode.light);
//       } else if (mode == ThemeMode.dark) {
//         themeProvider.setThemeMode(ThemeMode.dark);
//       } else {
//         themeProvider.useSystemTheme();
//       }
//     },
//   );
// }

// Widget _buildSectionContainer(BuildContext context, List<Widget> children) {
//   final theme = Theme.of(context);
//   return AnimatedContainer(
//     duration: const Duration(milliseconds: 300),
//     padding: const EdgeInsets.symmetric(vertical: 10),
//     decoration: BoxDecoration(
//       color: theme.cardColor.withOpacity(0.95),
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(children: children),
//   );
// }

// void _showConfirmDialog(
//   BuildContext context,
//   String title,
//   String message,
//   VoidCallback onConfirm,
// ) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
//       content: Text(message, style: GoogleFonts.lato(fontSize: 16)),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           onPressed: onConfirm,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.redAccent,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Text("Confirm"),
//         ),
//       ],
//     ),
//   );
// }

// void _showInfoDialog(BuildContext context, String title, String message) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
//       content: Text(message, style: GoogleFonts.lato(fontSize: 16)),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("OK"),
//         ),
//       ],
//     ),
//   );
// }

// class ProfilePage extends ConsumerWidget {
//   const ProfilePage({super.key});

//   Widget _buildSettingTile(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     Widget? trailing,
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: Theme.of(context).colorScheme.inverseSurface,
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.lato(
//             color: Theme.of(context).colorScheme.inverseSurface,
//           ),
//         ),
//         trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ref
//         .watch(currentUserProvider)
//         .when(
//           data: (data) {
//             return Scaffold(
//               backgroundColor: primaryColor,
//               body: CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     backgroundColor: primaryColor,
//                     floating: true,
//                     snap: true,
//                     elevation: 0,
//                     title: Text(
//                       "My Profile",
//                       style: GoogleFonts.lato(
//                         textStyle: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w900,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     centerTitle: false,
//                   ),

//                   // SliverToBoxAdapter(
//                   //   child: Container(
//                   //     width: double.infinity,
//                   //     decoration: BoxDecoration(
//                   //       color: Theme.of(context).colorScheme.surface,
//                   //       borderRadius: const BorderRadius.only(
//                   //         // topLeft: Radius.circular(16),
//                   //         topRight: Radius.circular(16),
//                   //       ),
//                   //     ),
//                   //     padding: const EdgeInsets.symmetric(
//                   //       horizontal: 16,
//                   //       vertical: 20,
//                   //     ),
//                   //     child: Column(
//                   //       crossAxisAlignment: CrossAxisAlignment.center,
//                   //       children: [
//                   //         // Avatar + Username
//                   //         Column(
//                   //           children: [
//                   //             CircleAvatar(
//                   //               radius: 60,
//                   //               backgroundImage: CachedNetworkImageProvider(
//                   //                 data.profilePic!,
//                   //               ),
//                   //             ),
//                   //             const SizedBox(height: 10),
//                   //             Text(
//                   //               data.username,
//                   //               style: GoogleFonts.lato(
//                   //                 fontSize: 26,
//                   //                 fontWeight: FontWeight.bold,
//                   //                 color: Theme.of(
//                   //                   context,
//                   //                 ).colorScheme.inverseSurface,
//                   //               ),
//                   //             ),
//                   //             const SizedBox(height: 8),
//                   //             Text(
//                   //               data.type.toUpperCase(),
//                   //               style: GoogleFonts.lato(
//                   //                 fontSize: 16,
//                   //                 fontWeight: FontWeight.w700,
//                   //                 color: Colors.blue[600],
//                   //               ),
//                   //             ),
//                   //             const SizedBox(height: 5),
//                   //             Wrap(
//                   //               spacing: 6,
//                   //               children: data.departement
//                   //                   .map(
//                   //                     (dept) => Chip(
//                   //                       label: Text(
//                   //                         dept,
//                   //                         style: GoogleFonts.lato(
//                   //                           fontWeight: FontWeight.w600,
//                   //                           color: Colors.white,
//                   //                         ),
//                   //                       ),
//                   //                       backgroundColor: primaryColor
//                   //                           .withOpacity(0.8),
//                   //                     ),
//                   //                   )
//                   //                   .toList(),
//                   //             ),
//                   //           ],
//                   //         ),

//                   //         const SizedBox(height: 20),

//                   //         // Social Icons
//                   //         Row(
//                   //           mainAxisAlignment: MainAxisAlignment.center,
//                   //           children: [
//                   //             IconButton(
//                   //               onPressed: () {},
//                   //               icon: Image.asset(
//                   //                 'assets/github.png',
//                   //                 width: 30,
//                   //                 height: 30,
//                   //               ),
//                   //             ),
//                   //             IconButton(
//                   //               onPressed: () {},
//                   //               icon: Image.asset(
//                   //                 'assets/icons8-google.png',
//                   //                 width: 30,
//                   //                 height: 30,
//                   //               ),
//                   //             ),
//                   //             IconButton(
//                   //               onPressed: () {},
//                   //               icon: Image.asset(
//                   //                 'assets/linkedin.png',
//                   //                 width: 30,
//                   //                 height: 30,
//                   //               ),
//                   //             ),
//                   //           ],
//                   //         ),

//                   //         const SizedBox(height: 25),

//                   //         // Followers
//                   //         Container(
//                   //           padding: const EdgeInsets.symmetric(
//                   //             horizontal: 12,
//                   //             vertical: 12,
//                   //           ),
//                   //           decoration: BoxDecoration(
//                   //             color: Colors.grey.shade100,
//                   //             borderRadius: BorderRadius.circular(15),
//                   //           ),
//                   //           child: Row(
//                   //             mainAxisAlignment: MainAxisAlignment.center,
//                   //             children: [
//                   //               Text(
//                   //                 "Followers: ",
//                   //                 style: GoogleFonts.lato(
//                   //                   fontSize: 22,
//                   //                   fontWeight: FontWeight.w800,
//                   //                   color: Theme.of(
//                   //                     context,
//                   //                   ).colorScheme.inverseSurface,
//                   //                 ),
//                   //               ),
//                   //               Text(
//                   //                 data.followers == 0
//                   //                     ? "No followers yet"
//                   //                     : data.followers.toString(),
//                   //                 style: GoogleFonts.lato(
//                   //                   fontSize: 22,
//                   //                   fontWeight: FontWeight.w500,
//                   //                   color: Theme.of(
//                   //                     context,
//                   //                   ).colorScheme.inverseSurface,
//                   //                 ),
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),

//                   //         const SizedBox(height: 20),

//                   //         // About Me Section
//                   //         Container(
//                   //           width: double.infinity,
//                   //           padding: const EdgeInsets.all(16),
//                   //           decoration: BoxDecoration(
//                   //             color: Theme.of(context).colorScheme.surface,
//                   //             borderRadius: BorderRadius.circular(15),
//                   //             boxShadow: [
//                   //               BoxShadow(
//                   //                 color: Colors.black.withOpacity(0.05),
//                   //                 blurRadius: 6,
//                   //                 offset: const Offset(0, 2),
//                   //               ),
//                   //             ],
//                   //           ),
//                   //           child: Column(
//                   //             crossAxisAlignment: CrossAxisAlignment.start,
//                   //             children: [
//                   //               Text(
//                   //                 "About Me",
//                   //                 style: GoogleFonts.lato(
//                   //                   fontSize: 20,
//                   //                   fontWeight: FontWeight.bold,
//                   //                   color: Theme.of(
//                   //                     context,
//                   //                   ).colorScheme.inverseSurface,
//                   //                 ),
//                   //               ),
//                   //               const SizedBox(height: 10),
//                   //               Text(
//                   //                 data.description?.isNotEmpty == true
//                   //                     ? data.description!
//                   //                     : "I am a CSCC Member!",
//                   //                 style: GoogleFonts.lato(
//                   //                   fontSize: 16,
//                   //                   color: Theme.of(
//                   //                     context,
//                   //                   ).colorScheme.inverseSurface,
//                   //                 ),
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),

//                   //         const SizedBox(height: 20),

//                   //         // Buttons
//                   //         FlatButton(
//                   //           text: "My Projects →",
//                   //           onPressed: () => Navigator.push(
//                   //             context,
//                   //             MaterialPageRoute(
//                   //               builder: (context) => MyProjectPage(),
//                   //             ),
//                   //           ),
//                   //           colour: primaryColor,
//                   //         ),
//                   //         const SizedBox(height: 10),
//                   //         FlatButton(
//                   //           text: "Settings →",
//                   //           onPressed: () => Navigator.push(
//                   //             context,
//                   //             MaterialPageRoute(
//                   //               builder: (context) => SettingPage(),
//                   //             ),
//                   //           ),
//                   //           colour: primaryColor,
//                   //         ),
//                   //         const SizedBox(height: 20),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//                   SliverToBoxAdapter(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.surface,
//                         borderRadius: const BorderRadius.only(
//                           topRight: Radius.circular(16),
//                         ),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 24,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // --- Profile header like in the picture ---
//                           Center(
//                             child: Column(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 40,
//                                   backgroundImage: CachedNetworkImageProvider(
//                                     data.profilePic!,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   data.username,
//                                   style: GoogleFonts.lato(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w700,
//                                     color: Theme.of(
//                                       context,
//                                     ).colorScheme.inverseSurface,
//                                   ),
//                                 ),
//                                 Text(
//                                   data.type,
//                                   style: GoogleFonts.lato(
//                                     fontSize: 14,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 Wrap(
//                                   spacing: 6,
//                                   runSpacing: -5,
//                                   alignment: WrapAlignment.center,
//                                   children: data.departement
//                                       .map(
//                                         (dept) => Chip(
//                                           label: Text(
//                                             dept,
//                                             style: GoogleFonts.lato(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           // backgroundColor: primaryColor.withOpacity(0.9),
//                                         ),
//                                       )
//                                       .toList(),
//                                 ),

//                                 // const SizedBox(height: 15),

//                                 // Followers
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 12,
//                                   ),
//                                   // decoration: BoxDecoration(
//                                   //   color: Colors.grey.shade100,
//                                   //   borderRadius: BorderRadius.circular(15),
//                                   // ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Followers: ",
//                                         style: GoogleFonts.lato(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w800,
//                                           color: Theme.of(
//                                             context,
//                                           ).colorScheme.inverseSurface,
//                                         ),
//                                       ),
//                                       Text(
//                                         data.followers == 0
//                                             ? "No followers yet"
//                                             : data.followers.toString(),
//                                         style: GoogleFonts.lato(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w400,
//                                           color: Theme.of(
//                                             context,
//                                           ).colorScheme.inverseSurface,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 25),

//                           Text(
//                             "Other settings",
//                             style: GoogleFonts.lato(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.inverseSurface,
//                             ),
//                           ),
//                           const SizedBox(height: 10),

//                           // --- Settings-like tiles ---
//                           _buildSettingTile(
//                             context,
//                             icon: Icons.person_outline,
//                             title: "About Me",
//                             onTap: () => {
//                               const SizedBox(height: 20),

//                               // About Me Section
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).colorScheme.surface,
//                                   borderRadius: BorderRadius.circular(15),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "About Me",
//                                       style: GoogleFonts.lato(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(
//                                           context,
//                                         ).colorScheme.inverseSurface,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Text(
//                                       data.description?.isNotEmpty == true
//                                           ? data.description!
//                                           : "I am a CSCC Member!",
//                                       style: GoogleFonts.lato(
//                                         fontSize: 16,
//                                         color: Theme.of(
//                                           context,
//                                         ).colorScheme.inverseSurface,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             },
//                           ),
//                           _buildSettingTile(
//                             context,
//                             icon: Icons.lock_outline,
//                             title: "Reset Password",
//                             onTap: () {
//                               _showInfoDialog(
//                                 context,
//                                 "Reset Password",
//                                 "Check your registered email to reset your password.",
//                               );
//                             },
//                           ),
//                           _buildSettingTile(
//                             context,
//                             icon: Icons.feedback,
//                             title: "Feed-back",
//                             onTap: () {
//                                _showInfoDialog(
//                                 context,
//                                 "Feedback",
//                                 "We will be happy to get your feedback !  contact us :  cht1485@gmail.com / laouar.romaissa.info@gmail.com",
//                               );
//                             },
//                           ),
//                           // _buildSettingTile(
//                           //   context,
//                           //   icon: Icons.notifications_none_outlined,
//                           //   title: "Notifications",
//                           //   onTap: () {},
//                           // ),
//                           _buildSectionContainer(context, [
//                             SwitchListTile(
//                               title: Text(
//                                 "Enable Notifications",
//                                 style: GoogleFonts.lato(fontSize: 18),
//                               ),
//                               secondary: const Icon(Icons.notifications_active_outlined),
//                               activeThumbColor: primaryColor,
//                               value: notificationsOn,
//                               onChanged: (value) {
//                                 setState(() => notificationsOn = value);
//                               },
//                             ),
//                           ]),
//                           // _buildSettingTile(
//                           //   context,
//                           //   icon: Icons.dark_mode_outlined,
//                           //   title: "Dark mode",
//                           //   trailing: Switch(
//                           //     value:
//                           //         Theme.of(context).brightness ==
//                           //         Brightness.dark,
//                           //     onChanged: (val) {},
//                           //   ),
//                           // ),
//                           _buildSectionContainer(context, [
//                             _buildThemeTile("Light mode", ThemeMode.light),
//                             _buildThemeTile("Dark mode", ThemeMode.dark),
//                             _buildThemeTile("System mode", ThemeMode.system),
//                           ]),

//                           const SizedBox(height: 15),
//                           _buildSettingTile(
//                             context,
//                             icon: Icons.info_outline,
//                             title: "About application",
//                             onTap: () {
//                                _showInfoDialog(
//                                 context,
//                                 "About the App",
//                                 "This app helps manage CSCC members and their activities efficiently.",
//                               );
//                             },
//                           ),
//                           _buildSettingTile(
//                             context,
//                             icon: Icons.help_outline,
//                             title: "Help & Support",
//                             onTap: () {
//                               _showInfoDialog(
//                                 context,
//                                 "Help",
//                                 "For support, please contact cscc.team@gmail.com",
//                               );
//                             },
//                           ),
//                           _buildSettingTile(
//                             context,
//                             icon: Icons.file_open_outlined,
//                             title: "My Projects",
//                             onTap: () => {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MyProjectPage(),
//                                 ),
//                               ),
//                             },
//                           ),

//                           const SizedBox(height: 15),
//                           Center(
//                             child: TextButton.icon(
//                               onPressed: _showConfirmDialog(
//                                 context,
//                                 "Delete Account",
//                                 "This action is irreversible. Do you want to continue?",
//                                 () {
//                                   // Add delete account logic here
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                               icon: const Icon(
//                                 Icons.delete_outline,
//                                 color: Colors.red,
//                               ),
//                               label: const Text(
//                                 "Delete Account",
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 10),
//                           Center(
//                             child: TextButton.icon(
//                               onPressed:  _showConfirmDialog(
//                                 context,
//                                 "Logout",
//                                 "Are you sure you want to logout?",
//                                 () async {
//                                   await ref.read(authServiceProvider).signOutUser();
//                                   if (mounted) Navigator.pop(context);
//                                 },
//                               ),
//                               icon: const Icon(
//                                 Icons.logout,
//                                 color: Colors.redAccent,
//                               ),
//                               label: const Text(
//                                 "Delete Account",
//                                 style: TextStyle(
//                                   color: Colors.redAccent,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           // Social Icons
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Image.asset(
//                                   'assets/github.png',
//                                   width: 30,
//                                   height: 30,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Image.asset(
//                                   'assets/icons8-google.png',
//                                   width: 30,
//                                   height: 30,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: Image.asset(
//                                   'assets/linkedin.png',
//                                   width: 30,
//                                   height: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//           error: (error, stackTrace) => Center(child: Text(error.toString())),
//           loading: () => const Center(child: CircularProgressIndicator()),
//         );
//   }
// }






// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cscc_app/cores/colors.dart';
// import 'package:cscc_app/cores/widgets/flat_button.dart';
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:cscc_app/features/profile/my_project_page.dart';
// import 'package:cscc_app/features/profile/setting_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfilePage extends ConsumerStatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   ConsumerState<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends ConsumerState<ProfilePage> {
//   String _themeMode = 'system';

//   @override
//   Widget build(BuildContext context) {
//     final userAsync = ref.watch(currentUserProvider);

//     return userAsync.when(
//       data: (data) {
//         return Scaffold(
//           backgroundColor: primaryColor,
//           appBar: AppBar(
//             backgroundColor: primaryColor,
//             elevation: 0,
//             title: Text(
//               "My Profile",
//               style: GoogleFonts.lato(
//                 textStyle: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(18),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Avatar + Username
//                   CircleAvatar(
//                     radius: 60,
//                     backgroundImage: CachedNetworkImageProvider(
//                       data.profilePic!,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     data.username,
//                     style: GoogleFonts.lato(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.inverseSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     data.type.toUpperCase(),
//                     style: GoogleFonts.lato(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.blue[600],
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Wrap(
//                     spacing: 6,
//                     children: data.departement
//                         .map(
//                           (dept) => Chip(
//                             label: Text(
//                               dept,
//                               style: GoogleFonts.lato(
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             backgroundColor: primaryColor.withOpacity(0.8),
//                           ),
//                         )
//                         .toList(),
//                   ),

//                   const SizedBox(height: 25),

//                   // Social Media Icons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: Image.asset(
//                           'assets/github.png',
//                           width: 30,
//                           height: 30,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: Image.asset(
//                           'assets/icons8-google.png',
//                           width: 30,
//                           height: 30,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: Image.asset(
//                           'assets/linkedin.png',
//                           width: 30,
//                           height: 30,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 25),

//                   // Followers + Following section
//                   StreamBuilder<DocumentSnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(FirebaseAuth.instance.currentUser!.uid)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const CircularProgressIndicator();
//                       }
//                       // final userDoc = snapshot.data!;
//                       // final followers = (userDoc['followers'] ?? []) as List;
//                       // final following = (userDoc['following'] ?? []) as List;

//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 // Text(
//                                 //   followers.length.toString(),
//                                 //   style: GoogleFonts.lato(
//                                 //     fontSize: 22,
//                                 //     fontWeight: FontWeight.bold,
//                                 //     color: Theme.of(context).colorScheme.inverseSurface,
//                                 //   ),
//                                 // ),
//                                 Text(
//                                   "Followers",
//                                   style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: 1,
//                               height: 25,
//                               color: Colors.grey[400],
//                             ),
//                             Column(
//                               children: [
//                                 // Text(
//                                 //   following.length.toString(),
//                                 //   style: GoogleFonts.lato(
//                                 //     fontSize: 22,
//                                 //     fontWeight: FontWeight.bold,
//                                 //     color: Theme.of(context).colorScheme.inverseSurface,
//                                 //   ),
//                                 // ),
//                                 Text(
//                                   "Following",
//                                   style: GoogleFonts.lato(
//                                     fontSize: 16,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 25),

//                   // About Me
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 6,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "About Me",
//                           style: GoogleFonts.lato(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).colorScheme.inverseSurface,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           data.description?.isNotEmpty == true
//                               ? data.description!
//                               : "I am a CSCC Member!",
//                           style: GoogleFonts.lato(
//                             fontSize: 16,
//                             color: Theme.of(context).colorScheme.inverseSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // My Projects Button
//                   FlatButton(
//                     text: "My Projects →",
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => MyProjectPage(),
//                         ),
//                       );
//                     },
//                     colour: primaryColor,
//                   ),

//                   const SizedBox(height: 25),

//                   // Settings Section
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 6,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Settings",
//                           style: GoogleFonts.lato(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).colorScheme.inverseSurface,
//                           ),
//                         ),
//                         const SizedBox(height: 10),

//                         // Theme mode radios
//                         Text(
//                           "Theme Mode:",
//                           style: GoogleFonts.lato(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             RadioListTile<String>(
//                               title: const Text('Light'),
//                               value: 'light',
//                               groupValue: _themeMode,
//                               onChanged: (val) {
//                                 setState(() => _themeMode = val!);
//                               },
//                             ),
//                             RadioListTile<String>(
//                               title: const Text('Dark'),
//                               value: 'dark',
//                               groupValue: _themeMode,
//                               onChanged: (val) {
//                                 setState(() => _themeMode = val!);
//                               },
//                             ),
//                             RadioListTile<String>(
//                               title: const Text('System'),
//                               value: 'system',
//                               groupValue: _themeMode,
//                               onChanged: (val) {
//                                 setState(() => _themeMode = val!);
//                               },
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 20),
//                         FlatButton(
//                           text: "Edit Profile →",
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SettingPage(),
//                               ),
//                             );
//                           },
//                           colour: primaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       error: (e, s) => Center(child: Text(e.toString())),
//       loading: () => const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cscc_app/cores/widgets/flat_button.dart';
// import 'package:cscc_app/features/auth/provider/providers.dart';
// import 'package:cscc_app/features/profile/my_project_page.dart';
// import 'package:cscc_app/features/profile/setting_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfilePage extends ConsumerWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ref
//         .watch(currentUserProvider)
//         .when(
//           data: (data) {
//             return Scaffold(
//               backgroundColor: const Color(0xFF4A8BFF),
//               body: SingleChildScrollView(
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height / 0.9,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 60,
//                         left: 10,
//                         child: Text(
//                           " MY PROFILE",
//                           style: GoogleFonts.lato(
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 150,
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height,
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.surface,
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(30),
//                               topRight: Radius.circular(30),
//                             ),
//                           ),

//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 15.0,
//                               vertical: 10,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).colorScheme.surface,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   // PROFILE AND NAME ROW
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(10.0),
//                                         child: Column(
//                                           children: [
//                                             CircleAvatar(
//                                               radius: 70,
//                                               backgroundImage:
//                                                   CachedNetworkImageProvider(
//                                                     data.profilePic!,
//                                                   ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Text(
//                                               data.username,

//                                               style: TextStyle(
//                                                 fontFamily: GoogleFonts.lato()
//                                                     .fontFamily,
//                                                 fontSize: 24,
//                                                 fontWeight: FontWeight.w800,
//                                                 color: Theme.of(context).colorScheme.inverseSurface,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(width: 30),
//                                       //NAME AND DEPARTMENT COLUMN
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                           top: 20.0,
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               data.type.toUpperCase(),
//                                               maxLines: 2,
//                                               style: TextStyle(
//                                                 fontFamily: GoogleFonts.lato()
//                                                     .fontFamily,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w800,
//                                                 color: Theme.of(context).colorScheme.inverseSurface,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             for (var dept in data.departement)
//                                               Text(
//                                                 dept,
//                                                 style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.blue[600],
//                                                 ),
//                                               ),
//                                             const SizedBox(height: 30),

//                                             Row(
//                                               children: [
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Image.asset(
//                                                     'assets/github.png',
//                                                     width: 35,
//                                                     height: 35,
//                                                   ),
//                                                 ),
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Image.asset(
//                                                     'assets/icons8-google.png',
//                                                     width: 35,
//                                                     height: 35,
//                                                   ),
//                                                 ),
//                                                 IconButton(
//                                                   onPressed: () {},
//                                                   icon: Image.asset(
//                                                     'assets/linkedin.png',
//                                                     width: 35,
//                                                     height: 35,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),

//                                 Container(
//                                   height: 60,
//                                   width: MediaQuery.sizeOf(context).width,
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Followers : ",
//                                           style: TextStyle(
//                                             fontFamily:
//                                                 GoogleFonts.lato().fontFamily,
//                                             fontSize: 26,
//                                             fontWeight: FontWeight.w800,
//                                             color: Theme.of(context).colorScheme.inverseSurface,
//                                           ),
//                                         ),
//                                         Text(
//                                           data.followers == 0
//                                               ? "No followers yet"
//                                               : data.followers.toString(),
//                                           style: TextStyle(
//                                             fontFamily:
//                                                 GoogleFonts.lato().fontFamily,
//                                             fontSize: 26,
//                                             fontWeight: FontWeight.w500,
//                                             color: Theme.of(context).colorScheme.inverseSurface,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(height: 10),
//                                 Container(
//                                   width: MediaQuery.sizeOf(context).width,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).colorScheme.surface,
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "About Me",
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Theme.of(context).colorScheme.inverseSurface,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         Text(
//                                           data.description?.isNotEmpty == true
//                                               ? data.description!
//                                               : "I am a CSCC Membre ! ",
//                                           softWrap: true,
//                                           overflow: TextOverflow.visible,
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Theme.of(context).colorScheme.inverseSurface,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 FlatButton(
//                                   text: "My Project ->",
//                                   onPressed: () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => MyProjectPage(),
//                                     ),
//                                   ),
//                                   colour: Colors.blue,
//                                 ),

//                                 const SizedBox(height: 10),
//                                 FlatButton(
//                                   text: "Settings ->",
//                                   onPressed: () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => SettingPage(),
//                                     ),
//                                   ),

//                                   colour: Colors.blue,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           error: (error, stackTrace) => Center(
//             child: Text(
//               error.toString(),
//               style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
//             ),
//           ),
//           loading: () => Center(child: CircularProgressIndicator()),
//         );
//   }
// }
