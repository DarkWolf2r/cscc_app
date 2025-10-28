// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../auth/model/user_model.dart';



// class ProfilePage extends ConsumerWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch the user data stream
//     final userData = ref.watch(userProvider);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F4F4),
//       body: userData.when(
//         data: (user) => _buildProfile(context, user),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(
//           child: Text('Error loading profile: $error'),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfile(BuildContext context, UserModel user) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Profile Header
//           _buildHeader(context, user),
          
//           // Info Cards
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 if (user.description != null)
//                   _buildInfoCard(
//                     'About',
//                     user.description!,
//                     Icons.person_outline,
//                   ),
//                 const SizedBox(height: 16),
//                 _buildInfoCard(
//                   'Departments',
//                   user.departement.join('\n'),
//                   Icons.work_outline,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildInfoCard(
//                   'Contact',
//                   user.email,
//                   Icons.email_outlined,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, UserModel user) {
//     return Container(
//       height: 240,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFF4A8BFF), Color(0xFF013A63)],
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           children: [
//             _buildAppBar(context),
//             _buildProfilePicture(user),
//             const SizedBox(height: 16),
//             _buildUserInfo(user),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           IconButton(
//             icon: const Icon(Icons.edit, color: Colors.white),
//             onPressed: () {
//               // TODO: Navigate to edit profile
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfilePicture(UserModel user) {
//     return CircleAvatar(
//       radius: 50,
//       backgroundColor: Colors.white,
//       child: user.profilePic != null
//           ? CircleAvatar(
//               radius: 47,
//               backgroundImage: NetworkImage(user.profilePic!),
//             )
//           : CircleAvatar(
//               radius: 47,
//               backgroundColor: const Color(0xFF4A8BFF),
//               child: Text(
//                 user.username[0].toUpperCase(),
//                 style: GoogleFonts.poppins(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildUserInfo(UserModel user) {
//     return Column(
//       children: [
//         Text(
//           user.username,
//           style: GoogleFonts.poppins(
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           user.type,
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             color: Colors.white70,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard(String title, String content, IconData icon) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: const Color(0xFF4A8BFF)),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             content,
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.grey[600],
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }