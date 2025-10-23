import 'package:cscc_app/cores/widgets/flat_button.dart';
import 'package:cscc_app/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

<<<<<<< HEAD
class HomePage extends ConsumerWidget {
  const HomePage({super.key});
=======
class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});
>>>>>>> 5574b4f (connect between sign in button and the home page)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('HOME PAGE')),
      body: Center(
        child: FlatButton(
          text: "SIGN OUT",
          onPressed: () {
            ref.read(authServiceProvider).signOutUser();
          },
          colour: Colors.black,
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:instagram_clone_flutter/utils/colors.dart';
// // import 'package:instagram_clone_flutter/utils/global_variable.dart';

// class MobileScreenLayout extends StatefulWidget {
//   const MobileScreenLayout({Key? key}) : super(key: key);

//   @override
//   State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
// }

// class _MobileScreenLayoutState extends State<MobileScreenLayout> {
//   int _page = 0;
//   late PageController pageController; // for tabs animation

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     pageController.dispose();
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   void navigationTapped(int page) {
//     //Animating Page
//     pageController.jumpToPage(page);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         children: homeScreenItems,
//       ),
//       bottomNavigationBar: CupertinoTabBar(
//         backgroundColor: mobileBackgroundColor,
//         items: <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               color: (_page == 0) ? primaryColor : secondaryColor,
//             ),
//             label: '',
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.search,
//                 color: (_page == 1) ? primaryColor : secondaryColor,
//               ),
//               label: '',
//               backgroundColor: primaryColor),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: (_page == 2) ? primaryColor : secondaryColor,
//               ),
//               label: '',
//               backgroundColor: primaryColor),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.favorite,
//               color: (_page == 3) ? primaryColor : secondaryColor,
//             ),
//             label: '',
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               color: (_page == 4) ? primaryColor : secondaryColor,
//             ),
//             label: '',
//             backgroundColor: primaryColor,
//           ),
//         ],
//         onTap: navigationTapped,
//         currentIndex: _page,
//       ),
//     );
//   }
// }
>>>>>>> 5574b4f (connect between sign in button and the home page)
